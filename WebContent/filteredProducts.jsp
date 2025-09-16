<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ellison Electronics - Filtered Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">

<%
/* Checking the user credentials - SAME AS index.jsp */
String userName = (String) session.getAttribute("username");
String password = (String) session.getAttribute("password");
String userType = (String) session.getAttribute("usertype");

boolean isValidUser = true;

if (userType == null || userName == null || password == null || !userType.equals("customer")) {
    isValidUser = false;
}
%>

    <jsp:include page="header.jsp" />

	
    <div class="container-fluid">
        <div class="row" style="margin-top: 10px;">
            
            <!-- Filter Sidebar -->
            <div class="col-lg-3 col-md-3" style="background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin-right: 10px;">
                <h4 style="color: #2d2d30; border-bottom: 2px solid #33cc33; padding-bottom: 10px;">
                    <i class="glyphicon glyphicon-filter"></i> Filter Products
                </h4>
                
                <form action="FilterProductsSrv" method="post" id="filterForm">
                    <div class="filter-section">
                        <h5 style="color: #2d2d30; margin-top: 20px;">Price Range</h5>
                        
                        <div class="checkbox-group">
                            <label class="filter-checkbox">
                                <input type="checkbox" name="priceRange" value="0-10000" 
                                    <%= request.getParameterValues("priceRange") != null && 
                                        java.util.Arrays.asList(request.getParameterValues("priceRange")).contains("0-10000") ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                Under ₹10,000
                            </label>
                            
                            <label class="filter-checkbox">
                                <input type="checkbox" name="priceRange" value="10000-30000"
                                    <%= request.getParameterValues("priceRange") != null && 
                                        java.util.Arrays.asList(request.getParameterValues("priceRange")).contains("10000-30000") ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                ₹10,000 - ₹30,000
                            </label>
                            
                            <label class="filter-checkbox">
                                <input type="checkbox" name="priceRange" value="30000-50000"
                                    <%= request.getParameterValues("priceRange") != null && 
                                        java.util.Arrays.asList(request.getParameterValues("priceRange")).contains("30000-50000") ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                ₹30,000 - ₹50,000
                            </label>
                            
                            <label class="filter-checkbox">
                                <input type="checkbox" name="priceRange" value="50000-100000"
                                    <%= request.getParameterValues("priceRange") != null && 
                                        java.util.Arrays.asList(request.getParameterValues("priceRange")).contains("50000-100000") ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                ₹50,000 - ₹1,00,000
                            </label>
                            
                            <label class="filter-checkbox">
                                <input type="checkbox" name="priceRange" value="100000-200000"
                                    <%= request.getParameterValues("priceRange") != null && 
                                        java.util.Arrays.asList(request.getParameterValues("priceRange")).contains("100000-200000") ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                ₹1,00,000 - ₹2,00,000
                            </label>
                        </div>
                        
                        <div style="margin-top: 20px;">
                            <button type="submit" class="btn btn-success btn-block">
                                <i class="glyphicon glyphicon-search"></i> Apply Filter
                            </button>
                            <a href="index.jsp" class="btn btn-default btn-block" style="margin-top: 10px;">
                                <i class="glyphicon glyphicon-refresh"></i> Clear All
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Products Display -->
            <div class="col-lg-8 col-md-8">
                <div class="row">
                    <div class="col-lg-12">
                        <h3 style="color: #2d2d30; text-align: center; margin-bottom: 30px;">
                            Filtered Products
                            <% 
                                List<ProductBean> filteredProducts = (List<ProductBean>) request.getAttribute("filteredProducts");
                                if (filteredProducts != null) {
                            %>
                            <span class="badge" style="background-color: #33cc33;"><%=filteredProducts.size()%> items</span>
                            <% } %>
                        </h3>
                    </div>
                </div>

                <div class="row">
                    <%
                        if (filteredProducts != null && !filteredProducts.isEmpty()) {
                            for (ProductBean product : filteredProducts) {
                                String description = product.getProdInfo();
                                description = description.substring(0, Math.min(description.length(), 100));
                                
                                // Get cart quantity like in index.jsp
                                int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
                    %>
                    <div class="col-sm-4" style="height: 350px;">
                        <div class="thumbnail products">
                            <img src="ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                            <p class="productname"><%=product.getProdName()%></p>
                            <% if (!description.isEmpty()) { %>
                                <p class="productinfo"><%=description%>..</p>
                            <% } %>
                            <p class="price">Rs <%=product.getProdPrice()%></p>
                            <form method="post">
                                <%
                                if (cartQty == 0) {
                                %>
                                <button type="submit" 
                                        formaction="AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" 
                                        class="btn btn-success">Add to Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit" 
                                        formaction="AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" 
                                        class="btn btn-primary">Buy Now</button>
                                <%
                                } else {
                                %>
                                <button type="submit" 
                                        formaction="AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" 
                                        class="btn btn-danger">Remove From Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit" formaction="cartDetails.jsp" 
                                        class="btn btn-success">Checkout</button>
                                <%
                                }
                                %>
                            </form>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="col-lg-12">
                        <div class="alert alert-info text-center">
                            <h4>No products found in the selected price range!</h4>
                            <p>Try adjusting your filters or <a href="index.jsp">view all products</a></p>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Removed auto-submit JavaScript for now -->

</body>
</html>
