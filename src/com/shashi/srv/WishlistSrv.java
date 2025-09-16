package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.service.impl.WishlistServiceImpl;

@WebServlet("/WishlistSrv")
public class WishlistSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("usertype");
        String action = request.getParameter("action");
        String prodId = request.getParameter("pid");
        
        WishlistServiceImpl wishlistService = new WishlistServiceImpl();
        
        // Check if user is logged in AND is a customer
        if (userName == null || !"customer".equals(userType)) {
            response.sendRedirect("login.jsp?message=Please login as customer to use wishlist!");
            return;
        }
        
        // Handle different actions
        if ("add".equals(action)) {
            // ✅ ADD TO WISHLIST
            if (prodId == null || prodId.trim().isEmpty()) {
                response.sendRedirect("userHome.jsp?message=Invalid product for wishlist!");
                return;
            }
            
            boolean success = wishlistService.addToWishlist(userName, prodId);
            String referer = request.getHeader("Referer");
            String redirectUrl = (referer != null && !referer.isEmpty()) ? referer : "userHome.jsp";
            
            if (success) {
                response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "message=Product added to wishlist!");
            } else {
                response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "message=Product already in wishlist!");
            }
            
        } else if ("remove".equals(action)) {
            // ✅ REMOVE FROM WISHLIST
            if (prodId == null || prodId.trim().isEmpty()) {
                response.sendRedirect("wishlist.jsp?message=Invalid product to remove!");
                return;
            }
            
            boolean success = wishlistService.removeFromWishlist(userName, prodId);
            String referer = request.getHeader("Referer");
            String redirectUrl = (referer != null && !referer.isEmpty()) ? referer : "wishlist.jsp";
            
            if (success) {
                response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "message=Product removed from wishlist!");
            } else {
                response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "message=Failed to remove product!");
            }
            
        } else if ("clear".equals(action)) {
            // ✅ CLEAR ENTIRE WISHLIST - This was missing!
            boolean success = wishlistService.clearWishlist(userName);
            
            if (success) {
                response.sendRedirect("wishlist.jsp?message=Wishlist cleared successfully!");
            } else {
                response.sendRedirect("wishlist.jsp?message=Failed to clear wishlist!");
            }
            
        } else {
            // ✅ INVALID ACTION
            response.sendRedirect("userHome.jsp?message=Invalid wishlist action!");
        }
    }
}
