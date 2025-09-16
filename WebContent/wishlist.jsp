<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>

<!DOCTYPE html>
<html>
<head>
<title>My Wishlist - Ellison Electronics</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">

<%
/* Checking the user credentials */
String userName = (String) session.getAttribute("username");
String password = (String) session.getAttribute("password");
String userType = (String) session.getAttribute("usertype");

if (userName == null || password == null || !"customer".equals(userType)) {
    response.sendRedirect("login.jsp?message=Please login to view your wishlist!");
    return;
}

// Get wishlist products
WishlistServiceImpl wishlistService = new WishlistServiceImpl();
List<ProductBean> wishlistProducts = wishlistService.getWishlistProducts(userName);
%>

<jsp:include page="header.jsp" />

<!-- Wishlist Header -->
<div class="container" style="margin-top: 20px;">
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span class="glyphicon glyphicon-heart" style="color: red;"></span>
                        &nbsp;My Wishlist (<%=wishlistProducts.size()%> items)
                    </h3>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Display Message -->
<%
String message = request.getParameter("message");
if (message != null) {
%>
<div class="container">
    <div class="alert alert-info alert-dismissible">
        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
        <strong><%=message%></strong>
    </div>
</div>
<%
}
%>

<!-- Wishlist Items -->
<div class="container">
    <%
    if (wishlistProducts.isEmpty()) {
    %>
    <!-- Empty Wishlist -->
    <div class="row">
        <div class="col-md-12 text-center" style="margin-top: 50px; margin-bottom: 50px;">
            <div class="panel panel-default">
                <div class="panel-body" style="padding: 50px;">
                    <span class="glyphicon glyphicon-heart-empty" style="font-size: 80px; color: #ccc;"></span>
                    <h3 style="color: #666;">Your wishlist is empty!</h3>
                    <p style="color: #999;">Save items you love so you don't lose sight of them.</p>
                    <a href="userHome.jsp" class="btn btn-primary btn-lg" style="margin-top: 20px;">
                        Continue Shopping
                    </a>
                </div>
            </div>
        </div>
    </div>
    <%
    } else {
    %>
    <!-- Wishlist Products -->
    <div class="row">
        <%
        for (ProductBean product : wishlistProducts) {
            // Check if product is in cart
            int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
        %>
        <div class="col-sm-6 col-md-4" style="margin-bottom: 30px;">
            <div class="thumbnail" style="height: 500px;">
                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
                     style="height: 200px; max-width: 100%; object-fit: contain;">
                
                <div class="caption">
                    <h4 class="productname"><%=product.getProdName()%></h4>
                    
                    <%
                    String description = product.getProdInfo();
                    if (description.length() > 80) {
                        description = description.substring(0, 80) + "...";
                    }
                    %>
                    <p class="productinfo"><%=description%></p>
                    
                    <p class="price" style="font-size: 18px; font-weight: bold; color: #e74c3c;">
                        Rs <%=product.getProdPrice()%>
                    </p>
                    
                    <!-- Action Buttons -->
                    <form method="post" style="margin-bottom: 10px;">
                        <%
                        if (cartQty == 0) {
                        %>
                        <button type="submit" 
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                                class="btn btn-success btn-block">
                            <span class="glyphicon glyphicon-shopping-cart"></span> Add to Cart
                        </button>
                        <%
                        } else {
                        %>
                        <button type="submit" 
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
                                class="btn btn-danger btn-block">
                            <span class="glyphicon glyphicon-remove"></span> Remove from Cart
                        </button>
                        <%
                        }
                        %>
                    </form>
                    
                    <!-- Remove from Wishlist -->
                    <form method="post">
                        <button type="submit" 
                                formaction="./WishlistSrv?action=remove&pid=<%=product.getProdId()%>"
                                class="btn btn-warning btn-block btn-sm">
                            <span class="glyphicon glyphicon-heart"></span> Remove from Wishlist
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <%
        }
        %>
    </div>
    
    <!-- Wishlist Actions -->
    <div class="row" style="margin-top: 30px;">
        <div class="col-md-12 text-center">
            <a href="userHome.jsp" class="btn btn-primary btn-lg">
                <span class="glyphicon glyphicon-shopping-cart"></span> Continue Shopping
            </a>
            &nbsp;&nbsp;&nbsp;
            <form method="post" style="display: inline-block;">
                <button type="submit" 
                        formaction="./WishlistSrv?action=clear" 
                        class="btn btn-danger btn-lg"
                        onclick="return confirm('Are you sure you want to clear your entire wishlist?')">
                    <span class="glyphicon glyphicon-trash"></span> Clear Wishlist
                </button>
            </form>
        </div>
    </div>
    <%
    }
    %>
</div>

<%@ include file="footer.html"%>

</body>
</html>
