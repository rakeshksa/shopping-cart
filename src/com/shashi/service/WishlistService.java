package com.shashi.service;

import java.util.List;
import com.shashi.beans.ProductBean;

public interface WishlistService {
    
    public boolean addToWishlist(String email, String prodId);
    
    public boolean removeFromWishlist(String email, String prodId);
    
    public List<ProductBean> getWishlistProducts(String email);
    
    public boolean isInWishlist(String email, String prodId);
    
    public int getWishlistCount(String email);
    
    public boolean clearWishlist(String email);
}
