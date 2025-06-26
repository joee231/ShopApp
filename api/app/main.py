from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from app.routers import user, products, cart

app = FastAPI()

app.mount("/static", StaticFiles(directory="images"), name="static")

# Include routers
app.include_router(user.router)
app.include_router(products.router)
app.include_router(cart.router)

@app.get("/test")
def test():
    return {"message": "Hello World"}