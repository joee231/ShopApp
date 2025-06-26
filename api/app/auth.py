from fastapi import HTTPException, status, Depends
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError

from app.utils import SECRET_KEY, ALGORITHM, decode_access_token
from app.database import fake_users_db

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
blacklisted_tokens = set()

async def get_current_user(token: str = Depends(oauth2_scheme)) -> str:
    if token in blacklisted_tokens:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token has been revoked")
    
    payload = decode_access_token(token)
    if payload is None:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    
    email: str = payload.get("sub")
    if not email or email not in fake_users_db:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    return email