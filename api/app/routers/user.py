from fastapi import APIRouter, HTTPException, Depends, status
from app.models import (
    NewUser, LoginRequest, ProfileUpdate, FCMTokenUpdate, EmailVerify,
    VerifyCodeRequest, ResetPasswordRequest, ChangePasswordRequest, UserAddress
)
from app.database import (
    fake_users_db, user_addresses, user_favorites, user_carts, email_verification_codes
)
from app.utils import get_password_hash, verify_password, create_access_token
from app.auth import get_current_user, blacklisted_tokens
import random

router = APIRouter()

@router.post("/register")
def register(user: NewUser):
    if user.email in fake_users_db:
        raise HTTPException(status_code=400, detail="Email already registered")

    user_id = len(fake_users_db) + 1

    # Store new user
    fake_users_db[user.email] = {
        "id": user_id,
        "hashed_password": get_password_hash(user.password),
        "name": user.name,
        "phone": user.phone,
        "image": "",
        "fcm_token": "",
        "points": 0,
        "credit": 0.0,
    }

    # Initialize related data
    user_addresses[user.email] = []
    user_favorites[user.email] = []
    user_carts[user.email] = []

    # Create token
    token = create_access_token(data={"sub": user.email})

    return {
        "status": True,
        "message": "User registered successfully",
        "data": {
            "id": user_id,
            "name": user.name,
            "email": user.email,
            "access_token": token
        }
    }

@router.post("/login")
def login(login_data: LoginRequest):
    user_record = fake_users_db.get(login_data.email)

    if not user_record or not verify_password(login_data.password, user_record["hashed_password"]):
        return {
            "status": False,
            "message": "Login failed",
            "data": None
        }

    token = create_access_token(data={"sub": login_data.email})

    return{
        "status": True,
        "message": "Login successful",
        "data": {
            "id": user_record["id"],
            "email": login_data.email,
            "name": user_record["name"],
            "phone": user_record["phone"],
            "image": user_record.get("image", ""),
            "points": user_record.get("points", 0),
            "credit": user_record.get("credit", 0.0),
            "addresses": user_addresses.get(login_data.email, []),
            "access_token": token,
            "token_type": "bearer",
        }
    }

@router.get("/me")
def get_me(current_user: str = Depends(get_current_user)):
    return {"email": current_user}

@router.get("/profile")
def get_profile(current_user: str = Depends(get_current_user)):
    user_data = fake_users_db.get(current_user)
    return {
        "status": True,
        "message": "User profile fetched successfully",
        "data": {
            "id": user_data["id"],
            "email": current_user,
            "name": user_data.get("name"),
            "phone": user_data.get("phone"),
            "image": user_data.get("image", "")
        }
    }
    
@router.put("/update-profile")
def update_profile(
    update: ProfileUpdate,
    current_user: str = Depends(get_current_user)
):
    if update.email != current_user and update.email in fake_users_db:
        raise HTTPException(status_code=400, detail="Email already in use")

    current_data = fake_users_db[current_user]

    updated_user = {
        "id": current_data["id"],
        "hashed_password": current_data["hashed_password"],
        "name": update.name,
        "phone": update.phone,
        "image": current_data.get("image", ""),
        "fcm_token": current_data.get("fcm_token", ""),
        "points": current_data.get("points", 0),
        "credit": current_data.get("credit", 0.0),
    }

    if update.email != current_user:
        fake_users_db[update.email] = updated_user
        user_addresses[update.email] = user_addresses.pop(current_user, [])
        user_favorites[update.email] = user_favorites.pop(current_user, [])
        user_carts[update.email] = user_carts.pop(current_user, [])
        del fake_users_db[current_user]
        current_user = update.email

    else:
        fake_users_db[current_user].update(updated_user)

    # Re-generate token since email might have changed or simply to refresh it
    token = create_access_token(data={"sub": current_user})

    return {
        "status": True,
        "message": "Profile updated successfully",
        "data": {
            "id": updated_user["id"],
            "email": current_user,
            "name": update.name,
            "phone": update.phone,
            "image": updated_user["image"],
            "points": updated_user["points"],
            "credit": updated_user["credit"],
            "addresses": user_addresses.get(current_user, []),
            "access_token": token,
            "token_type": "bearer"
        }
    }
    
# Address routes
@router.get("/addresses")
def get_addresses(current_user: str = Depends(get_current_user)):
    return {"addresses": user_addresses.get(current_user, [])}

@router.post("/addresses")
def create_address(address: UserAddress, current_user: str = Depends(get_current_user)):
    user_addresses[current_user].append(address.model_dump())
    return {"message": "Address created", "address": address}

@router.put("/addresses/{address_id}")
def update_address(address_id: int, new_address: UserAddress, current_user: str = Depends(get_current_user)):
    addresses = user_addresses.get(current_user, [])
    for i, addr in enumerate(addresses):
        if addr["id"] == address_id:
            user_addresses[current_user][i] = new_address.model_dump()
            return {"message": "Address updated", "address": new_address}
    raise HTTPException(status_code=404, detail="Address not found")

@router.delete("/addresses/{address_id}")
def delete_address(address_id: int, current_user: str = Depends(get_current_user)):
    addresses = user_addresses.get(current_user, [])
    for i, addr in enumerate(addresses):
        if addr["id"] == address_id:
            del user_addresses[current_user][i]
            return {"message": "Address deleted"}
    raise HTTPException(status_code=404, detail="Address not found")

# FCM Token
@router.post("/fcm-token")
def update_fcm_token(data: FCMTokenUpdate, current_user: str = Depends(get_current_user)):
    if current_user not in fake_users_db:
        raise HTTPException(status_code=404, detail="User not found")
    fake_users_db[current_user]["fcm_token"] = data.fcm_token
    return {"message": "FCM token updated successfully"}

# Logout
@router.post("/logout")
def logout(token: str = Depends(get_current_user)): # Use get_current_user to validate token first
    # The token itself is passed from the Depends(oauth2_scheme) in get_current_user
    # We need the raw token to blacklist it, which get_current_user doesn't expose directly.
    # So, we'll re-depend on oauth2_scheme here.
    from fastapi.security import OAuth2PasswordBearer
    oauth2_scheme_local = OAuth2PasswordBearer(tokenUrl="login") # Re-instantiate locally
    token_to_blacklist = Depends(oauth2_scheme_local)
    
    blacklisted_tokens.add(token_to_blacklist)
    return {"message": "Logged out successfully"}

# Email Verification & Password Reset
@router.post("/verify-email")
def send_verification_code(data: EmailVerify):
    if data.email not in fake_users_db:
        raise HTTPException(status_code=404, detail="Email not found")
    code = str(random.randint(100000, 999999))
    email_verification_codes[data.email] = code
    return {"message": f"Verification code sent to {data.email}", "code": code}

@router.post("/verify-code")
def verify_code(data: VerifyCodeRequest):
    if email_verification_codes.get(data.email) == data.code:
        return {"message": "Verification successful"}
    raise HTTPException(status_code=400, detail="Invalid verification code")

@router.post("/reset-password")
def reset_password(data: ResetPasswordRequest):
    if data.email not in fake_users_db:
        raise HTTPException(status_code=404, detail="Email not found")
    fake_users_db[data.email]["hashed_password"] = get_password_hash(data.new_password)
    return {"message": "Password reset successfully"}

@router.post("/change-password")
def change_password(data: ChangePasswordRequest, current_user: str = Depends(get_current_user)):
    user = fake_users_db.get(current_user)
    if not verify_password(data.old_password, user["hashed_password"]):
        raise HTTPException(status_code=400, detail="Incorrect old password")
    user["hashed_password"] = get_password_hash(data.new_password)
    return {"message": "Password changed successfully"}