from fastapi import APIRouter, HTTPException, Depends
from app.database import user_carts, product_list
from app.models import CartItemUpdate, CartToggleRequest
from app.auth import get_current_user

router = APIRouter()

BASE_IMAGE_URL = "http://192.168.1.3:41654/static"

@router.get("/carts")
def get_cart(current_user: str = Depends(get_current_user)):
    cart_items = user_carts.get(current_user, [])
    cart_data = []

    for item in cart_items:
        if isinstance(item, dict):
            product_id = item.get("product_id")
            quantity = item.get("quantity", 1)
        else:
            # fallback if legacy format was just product_id
            product_id = item
            quantity = 1

        product = next((p for p in product_list if p["id"] == product_id), None)
        if product:
            cart_entry = {
                "id": product_id,
                "product": {
                    "product_id": product["id"],
                    "price": product["price"],
                    "old_price": round(product["price"] * 1.2, 2),
                    "discount": 20,
                    "quantity": quantity,
                    "image": f"{BASE_IMAGE_URL}/product_{product['id']}.jpg",
                    "name": product["name"],
                    "description": product["description"]
                }
            }
            cart_data.append(cart_entry)

    # Fake list of available promo codes
    promo_codes = [
        {"code": "SUMMER25", "discount_percent": 25, "description": "25% off summer sale"},
        {"code": "FREESHIP", "discount_percent": 0, "description": "Free shipping on all orders"},
        {"code": "WELCOME10", "discount_percent": 10, "description": "10% off for new users"},
    ]

    return {
        "status": True,
        "message": "Cart fetched successfully",
        "data": {
            "current_page": 1,
            "data": cart_data,
            "promocodes": promo_codes
        }
    }

@router.post("/carts")
def toggle_cart(data: CartToggleRequest, current_user: str = Depends(get_current_user)):
    product_id = data.product_id
    cart = user_carts.setdefault(current_user, [])
    message = ""

    # Check if product already exists in the cart
    existing_item = next((item for item in cart if item.get("product_id") == product_id), None)

    if existing_item:
        cart.remove(existing_item)
        message = "Removed from cart"
    else:
        cart.append({"product_id": product_id, "quantity": 1})
        message = "Added to cart"

    # Build updated cart response
    response_data = []
    for item in cart:
        product = next((p for p in product_list if p["id"] == item["product_id"]), None)
        if product:
            response_data.append({
                "id": item["product_id"],
                "product": {
                    "product_id": product["id"],
                    "price": product["price"],
                    "old_price": round(product["price"] * 1.2, 2),
                    "discount": 20,
                    "quantity": item.get("quantity", 1),
                    "image": f"{BASE_IMAGE_URL}/product_{product['id']}.jpg",
                    "name": product["name"],
                    "description": product["description"]
                }
            })

    return {
        "status": True,
        "message": message,
        "data": {
            "current_page": 1,
            "data": response_data
        }
    }

@router.put("/carts/{product_id}")
def update_cart(product_id: int, update: CartItemUpdate, current_user: str = Depends(get_current_user)):
    cart = user_carts.get(current_user, [])
    for item in cart:
        if item["product_id"] == product_id:
            item["quantity"] = update.quantity

            # Prepare response data
            cart_data = [
                {"product_id": i["product_id"], "quantity": i["quantity"]}
                for i in cart
            ]

            return {
                "status": True,
                "message": "Cart updated",
                "data": cart_data
            }

    raise HTTPException(status_code=404, detail="Product not in cart")

@router.delete("/carts")
def clear_cart(current_user: str = Depends(get_current_user)):
    user_carts[current_user] = []
    return {"message": "Cart cleared"}