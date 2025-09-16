package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.ProductBean;
import com.shashi.service.WishlistService;
import com.shashi.utility.DBUtil;

public class WishlistServiceImpl implements WishlistService {

    @Override
    public boolean addToWishlist(String email, String prodId) {
        boolean flag = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        
        try {
            // Check if already in wishlist
            if (isInWishlist(email, prodId)) {
                return false; // Already in wishlist
            }
            
            ps = con.prepareStatement("INSERT INTO wishlist (email, prodid) VALUES (?, ?)");
            ps.setString(1, email);
            ps.setString(2, prodId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                flag = true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        
        return flag;
    }

    @Override
    public boolean removeFromWishlist(String email, String prodId) {
        boolean flag = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        
        try {
            ps = con.prepareStatement("DELETE FROM wishlist WHERE email = ? AND prodid = ?");
            ps.setString(1, email);
            ps.setString(2, prodId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                flag = true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        
        return flag;
    }

    @Override
    public List<ProductBean> getWishlistProducts(String email) {
        List<ProductBean> wishlistProducts = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            ps = con.prepareStatement(
                "SELECT p.pid, p.pname, p.ptype, p.pinfo, p.pprice, p.pquantity, p.image " +
                "FROM product p INNER JOIN wishlist w ON p.pid = w.prodid " +
                "WHERE w.email = ? ORDER BY w.added_date DESC"
            );
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString(1));
                product.setProdName(rs.getString(2));
                product.setProdType(rs.getString(3));
                product.setProdInfo(rs.getString(4));
                product.setProdPrice(rs.getDouble(5));
                product.setProdQuantity(rs.getInt(6));
                product.setProdImage(rs.getAsciiStream(7));
                
                wishlistProducts.add(product);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        DBUtil.closeConnection(rs);
        
        return wishlistProducts;
    }

    @Override
    public boolean isInWishlist(String email, String prodId) {
        boolean exists = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            ps = con.prepareStatement("SELECT COUNT(*) FROM wishlist WHERE email = ? AND prodid = ?");
            ps.setString(1, email);
            ps.setString(2, prodId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        DBUtil.closeConnection(rs);
        
        return exists;
    }

    @Override
    public int getWishlistCount(String email) {
        int count = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            ps = con.prepareStatement("SELECT COUNT(*) FROM wishlist WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        DBUtil.closeConnection(rs);
        
        return count;
    }

    @Override
    public boolean clearWishlist(String email) {
        boolean flag = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        
        try {
            ps = con.prepareStatement("DELETE FROM wishlist WHERE email = ?");
            ps.setString(1, email);
            
            int result = ps.executeUpdate();
            if (result >= 0) { // Even 0 is success (empty wishlist)
                flag = true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        DBUtil.closeConnection(con);
        DBUtil.closeConnection(ps);
        
        return flag;
    }
}
