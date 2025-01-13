import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from groq import Groq
from dotenv import load_dotenv
from typing import List

# Load environment variables from .env file
load_dotenv()

# Groq API setup
GROQ_API_KEY = os.getenv("GROQ_API_KEY")
if not GROQ_API_KEY:
    raise RuntimeError("GROQ_API_KEY environment variable is missing.")
client = Groq(api_key=GROQ_API_KEY)

# Database setup
DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)
Base = declarative_base()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Models
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    age = Column(Integer, nullable=False)
    sex = Column(String(10), nullable=False)
    location = Column(String(100), nullable=False)
    education = Column(String(200), nullable=False)
    professional_details = Column(Text, nullable=False)

class Personality(Base):
    __tablename__ = "personality"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    question = Column(Text, nullable=False)
    response = Column(Text, nullable=False)

Base.metadata.create_all(bind=engine)

# FastAPI app
app = FastAPI()

# Pydantic models
class UserInput(BaseModel):
    name: str
    age: int
    sex: str
    location: str
    education: str
    professional_details: str

class PersonalityInput(BaseModel):
    user_id: int
    question: str
    response: str

class PersonalityBatchInput(BaseModel):
    user_id: int
    entries: List[PersonalityInput]

class MessageInput(BaseModel):
    user_id: int
    message: str

class SignInInput(BaseModel):
    name: str

# Endpoints
@app.post("/users/")
def create_user(user: UserInput):
    """Create a new user with details."""
    session = SessionLocal()
    try:
        new_user = User(**user.dict())
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        return {"message": "User created successfully", "user_id": new_user.id}
    finally:
        session.close()

@app.post("/users/signin/")
def sign_in_user(sign_in: SignInInput):
    """Sign in an existing user by name."""
    session = SessionLocal()
    try:
        user = session.query(User).filter(User.name == sign_in.name).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        return {"message": "Sign-in successful", "user_id": user.id}
    finally:
        session.close()

@app.post("/personality/")
def add_personality_entries(entries: PersonalityBatchInput):
    """Add multiple personality questionnaire responses for a user."""
    session = SessionLocal()
    try:
        for entry in entries.entries:
            new_entry = Personality(**entry.dict())
            session.add(new_entry)
        session.commit()
        return {"message": "Personality entries added"}
    finally:
        session.close()

@app.get("/users/")
def get_users():
    """Fetch all users."""
    session = SessionLocal()
    try:
        users = session.query(User).all()
        return [{"id": user.id, "name": user.name} for user in users]
    finally:
        session.close()

@app.post("/simulate/")
def simulate_response(message: MessageInput):
    """Simulate a response based on the user's personality."""
    session = SessionLocal()
    try:
        user = session.query(User).filter(User.id == message.user_id).first()
        personality_entries = session.query(Personality).filter(Personality.user_id == message.user_id).all()

        if not user or not personality_entries:
            raise HTTPException(status_code=404, detail="User or personality data not found")

        personality_data = "\n".join([f"{entry.question}: {entry.response}" for entry in personality_entries])

        prompt = f"""
User Details:
- Name: {user.name}
- Age: {user.age}
- Sex: {user.sex}
- Location: {user.location}
- Education: {user.education}
- Professional Details: {user.professional_details}

Personality Details:
{personality_data}

Message:
"{message.message}"

Generate a response that mimics the user's communication style.
"""

        response = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model="llama-3.3-70b-versatile"
        )
        return {"response": response.choices[0].message.content}
    finally:
        session.close()
