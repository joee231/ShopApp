from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# --- Simulated Database ---
fake_users_db = {
    "test@example.com": {
        "id": 1 ,
        "hashed_password": pwd_context.hash("123456"),
        "name": "Test User",
        "phone": "0100000000",
        "image": "",
        "fcm_token": "",
        "points": 1000,
        "credit": 500.0,
    }
}
user_addresses = {"test@example.com": []}
user_favorites = {"test@example.com": []}
user_carts = {"test@example.com": []}
email_verification_codes = {}

product_list = [
    {"id": 1, "name": "Laptop", "description": "High-performance gaming laptop with RTX graphics and SSD storage.", "price": 1500.0, "category_id": 1},
    {"id": 2, "name": "Mouse", "description": "Ergonomic wireless mouse with adjustable DPI and long battery life.", "price": 25.0, "category_id": 1},
    {"id": 3, "name": "Shirt", "description": "Premium cotton shirt suitable for formal and casual occasions.", "price": 40.0, "category_id": 2},
    {"id": 4, "name": "Phone", "description": "Flagship smartphone with stunning display and excellent camera quality.", "price": 999.0, "category_id": 1},
    {"id": 5, "name": "Watch", "description": "Stylish digital watch with multiple functionalities and water resistance.", "price": 120.0, "category_id": 2},
    {"id": 6, "name": "Headphones", "description": "Noise-cancelling over-ear headphones with deep bass and clear sound.", "price": 85.0, "category_id": 1},
    {"id": 7, "name": "Backpack", "description": "Durable backpack with multiple compartments and ergonomic support.", "price": 60.0, "category_id": 2},
    {"id": 8, "name": "Desk Lamp", "description": "LED desk lamp with brightness control and USB charging port.", "price": 35.0, "category_id": 3},
    {"id": 9, "name": "Blender", "description": "High-speed blender perfect for smoothies and meal prep.", "price": 70.0, "category_id": 3},
    {"id": 10, "name": "Yoga Mat", "description": "Non-slip yoga mat with extra cushioning for joint support.", "price": 30.0, "category_id": 5},
    {"id": 11, "name": "Running Shoes", "description": "Lightweight running shoes designed for comfort and speed.", "price": 90.0, "category_id": 5},
    {"id": 12, "name": "Cookware Set", "description": "Complete set of non-stick cookware for all your kitchen needs.", "price": 110.0, "category_id": 3},
    {"id": 13, "name": "Notebook", "description": "Compact and powerful notebook ideal for students and professionals.", "price": 700.0, "category_id": 1},
    {"id": 14, "name": "Smart TV", "description": "Ultra HD smart TV with streaming support and vivid colors.", "price": 499.0, "category_id": 1},
    {"id": 15, "name": "Sunglasses", "description": "Fashionable UV-protected sunglasses suitable for all seasons.", "price": 45.0, "category_id": 2}
]

categories = [
    {"id": 1, "name": "Electronics" , "description": "Devices and gadgets"},
    {"id": 2, "name": "Fashion", "description": "Clothing and accessories"},
    {"id": 3, "name": "Home", "description": "Home appliances and furniture"},
    {"id": 4, "name": "Books", "description": "Books and literature"},
    {"id": 5, "name": "Sports", "description": "Sports equipment and apparel"},
]