import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from groq import Groq
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Groq API setup
client = Groq(api_key=os.getenv("GROQ_API_KEY"))

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

class MessageInput(BaseModel):
    user_id: int
    message: str

# Endpoints
@app.post("/users/")
def create_user(user: UserInput):
    session = SessionLocal()
    new_user = User(**user.dict())
    session.add(new_user)
    session.commit()
    session.refresh(new_user)
    session.close()
    return {"message": "User created successfully", "user_id": new_user.id}

@app.post("/personality/")
def add_personality_entry(entry: PersonalityInput):
    session = SessionLocal()
    new_entry = Personality(**entry.dict())
    session.add(new_entry)
    session.commit()
    session.close()
    return {"message": "Personality entry added"}

@app.get("/users/")
def get_users():
    session = SessionLocal()
    users = session.query(User).all()
    session.close()
    return [{"id": user.id, "name": user.name} for user in users]

@app.post("/simulate/")
def simulate_response(message: MessageInput):
    session = SessionLocal()
    user = session.query(User).filter(User.id == message.user_id).first()
    personality_entries = session.query(Personality).filter(Personality.user_id == message.user_id).all()
    session.close()

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
