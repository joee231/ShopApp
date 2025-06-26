from pydantic import BaseModel, EmailStr
import random

class UserAddress(BaseModel):
    id: int = random.randint(1, 1000)
    name: str
    city: str
    region: str
    details: str
    notes: str
    latitude: float
    longitude: float

class NewUser(BaseModel):
    email: EmailStr
    password: str
    name: str
    phone: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class ProfileUpdate(BaseModel):
    email: EmailStr
    name: str
    phone: str

class CartItemCreate(BaseModel):
    product_id: int

class CartItemUpdate(BaseModel):
    quantity: int

class FCMTokenUpdate(BaseModel):
    fcm_token: str

class EmailVerify(BaseModel):
    email: EmailStr

class VerifyCodeRequest(BaseModel):
    email: EmailStr
    code: str

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    new_password: str

class ChangePasswordRequest(BaseModel):
    old_password: str
    new_password: str

class Categories(BaseModel):
    id: int # This will be populated from data, not randomly assigned in the model
    name: str
    description: str

class SearchRequest(BaseModel):
    text: str

class FavoriteToggleRequest(BaseModel):
    product_id: int

class CartToggleRequest(BaseModel):
    product_id: int