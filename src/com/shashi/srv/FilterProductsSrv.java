package com.shashi.srv;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/FilterProductsSrv")
public class FilterProductsSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get selected price ranges from request
        String[] selectedRanges = request.getParameterValues("priceRange");
        
        ProductServiceImpl productService = new ProductServiceImpl();
        List<ProductBean> filteredProducts;
        
        if (selectedRanges != null && selectedRanges.length > 0) {
            List<String> priceRanges = new ArrayList<>();
            for (String range : selectedRanges) {
                priceRanges.add(range);
            }
            filteredProducts = productService.getProductsByMultiplePriceRanges(priceRanges);
        } else {
            // No filters selected, show all products
            filteredProducts = productService.getAllProducts();
        }
        
        // Set filtered products as request attribute
        request.setAttribute("filteredProducts", filteredProducts);
        request.setAttribute("selectedRanges", selectedRanges);
        
        // Forward to the product display page
        RequestDispatcher rd = request.getRequestDispatcher("filteredProducts.jsp");
        rd.forward(request, response);
    }
}
