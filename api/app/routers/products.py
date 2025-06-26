from fastapi import APIRouter, HTTPException, Query, Depends
from app.database import product_list, categories, user_favorites, user_carts
from app.models import SearchRequest
from app.auth import get_current_user

router = APIRouter()

BASE_IMAGE_URL = "http://192.168.1.3:41654/static"

@router.get("/products")
def get_products(category_id: int = Query(None)):
    if category_id:
        return {"products": [p for p in product_list if p["category_id"] == category_id]}
    return {"products": product_list}

@router.post("/products/search")
def search_products(data: SearchRequest, current_user: str = Depends(get_current_user)):
    results = []
    query = data.text.lower()

    for product in product_list:
        if query in product["name"].lower():
            results.append({
                "id": product["id"],
                "price": product["price"],
                "old_price": round(product["price"] * 1.2, 2),
                "discount": 20,
                "image": f"{BASE_IMAGE_URL}/product_{product['id']}.jpg",
                "name": product["name"],
                "description": product["description"]
            })
    if not results:
        raise HTTPException(status_code=404, detail="No products found")

    return {
        "status": True,
        "message": "Search completed",
        "data": {
            "current_page": 1,
            "data": results
        }
    }

@router.get("/products/{product_id}")
def get_product_detail(product_id: int):
    for product in product_list:
        if product["id"] == product_id:
            return product
    raise HTTPException(status_code=404, detail="Product not found")

@router.get("/categories")
def get_categories(current_user: str = Depends(get_current_user)):
    category_data = [
        {
            "id": cat["id"],
            "name": cat["name"],
            "image": f"{BASE_IMAGE_URL}/category_{cat['id']}.jpg"
        }
        for cat in categories
    ]
    
    return {
        "status": True,
        "message": "Categories fetched successfully",
        "data": {
            "current_page": 1,
            "data": category_data
        }
    }

@router.get("/categories/{category_id}")
def get_products_by_category(category_id: int, current_user: str = Depends(get_current_user)):
    category_products = [
        {
            "id": p["id"],
            "price": p["price"],
            "old_price": round(p["price"] * 1.2, 2),
            "discount": 20,
            "image": f"{BASE_IMAGE_URL}/product_{p['id']}.jpg",
            "name": p["name"],
            "description": p["description"],
            "category_id": p["category_id"]
        }
        for p in product_list if p["category_id"] == category_id
    ]

    return {
        "status": True,
        "message": "Products fetched successfully",
        "data": category_products
    }

# Favorites routes
@router.get("/favorites")
def get_favorites(current_user: str = Depends(get_current_user)):
    favorite_ids = user_favorites.get(current_user, [])
    favorites_data = []

    for product_id in favorite_ids:
        product = next((p for p in product_list if p["id"] == product_id), None)
        if product:
            favorite_entry = {
                "id": product_id,
                "product": {
                    "id": product["id"],
                    "price": product["price"],
                    "old_price": round(product["price"] * 1.2, 2),
                    "discount": 20,
                    "image": f"{BASE_IMAGE_URL}/product_{product['id']}.jpg",
                    "name": product["name"],
                    "description": product["description"]
                }
            }
            favorites_data.append(favorite_entry)

    return {
        "status": True,
        "message": "Favorites fetched successfully",
        "data": {
            "current_page": 1,
            "data": favorites_data
        }
    }

from app.models import FavoriteToggleRequest

@router.post("/favorites")
def toggle_favorite(data: FavoriteToggleRequest, current_user: str = Depends(get_current_user)):
    product_id = data.product_id
    favorites = user_favorites.setdefault(current_user, [])
    message = ""

    if product_id in favorites:
        favorites.remove(product_id)
        message = "Removed from favorites"
    else:
        favorites.append(product_id)
        message = "Added to favorites"

    # Generate favorite entries
    response_data = []
    for fav_product_id in favorites:
        product = next((p for p in product_list if p["id"] == fav_product_id), None)
        if product:
            favorite_entry = {
                "id": fav_product_id,
                "product": {
                    "product_id": product["id"],
                    "price": product["price"],
                    "old_price": round(product["price"] * 1.2, 2),
                    "discount": 20,
                    "image": f"{BASE_IMAGE_URL}/product_{product['id']}.jpg"
                }
            }
            response_data.append(favorite_entry)

    return {
        "status": True,
        "message": message,
        "data": response_data
    }

@router.delete("/favorites")
def clear_favorites(current_user: str = Depends(get_current_user)):
    user_favorites[current_user] = []
    return {"message": "Favorites cleared"}

@router.get("/home")
def home(
    category_id: int = Query(None),
    current_user: str = Depends(get_current_user)
):
    user_favs = user_favorites.get(current_user, [])
    user_cart_items = user_carts.get(current_user, [])
    user_cart_product_ids = [item["product_id"] for item in user_cart_items]

    filtered_products = (
        [p for p in product_list if p["category_id"] == category_id]
        if category_id else product_list
    )

    banners = [
        {
            "id": p["id"],
            "image": f"{BASE_IMAGE_URL}/product_{p['id']}_1.jpg",
            "category": next((c for c in categories if c["id"] == p["category_id"]), {}),
            "product": {
                "id": p["id"],
                "name": p["name"],
                "price": p["price"]
            }
        } for p in filtered_products[:3]
    ]

    detailed_products = [
        {
            "id": p["id"],
            "price": p["price"],
            "old_price": round(p["price"] * 1.2, 2),
            "discount": 20,
            "image": f"{BASE_IMAGE_URL}/product_{p['id']}.jpg",
            "name": p["name"],
            "description": p["description"],
            "images": [
                f"{BASE_IMAGE_URL}/product_{p['id']}_1.jpg",
                f"{BASE_IMAGE_URL}/product_{p['id']}_2.jpg"
            ],
            "in_favorites": p["id"] in user_favs,
            "in_cart": p["id"] in user_cart_product_ids,
            "category_id": p["category_id"],
        } for p in filtered_products
    ]

    ads = {
        "id": 1,
        "title": "50% Off Today Only!",
        "image": f"{BASE_IMAGE_URL}/ad_banner.jpg",
        "url": "https://example.com/offers"
    }

    return {
        "status": True,
        "message": "Home data fetched successfully",
        "data": {
            "banners": banners,
            "products": detailed_products,
            "ads": ads
        }
    }