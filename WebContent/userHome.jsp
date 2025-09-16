<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Ellison Electronics</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {
		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	// UPDATED: Added price filter support
	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String priceFilter = request.getParameter("priceFilter");
	String message = "All Products";

	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else if (priceFilter != null) {
		// Price filtering logic
		products = prodDao.getAllProducts();
		List<ProductBean> filteredProducts = new ArrayList<ProductBean>();

		if (priceFilter.equals("0-10000")) {
			for (ProductBean p : products) {
		if (p.getProdPrice() <= 10000) {
			filteredProducts.add(p);
		}
			}
			message = "Products Under Rs 10,000";
		} else if (priceFilter.equals("10000-30000")) {
			for (ProductBean p : products) {
		if (p.getProdPrice() > 10000 && p.getProdPrice() <= 30000) {
			filteredProducts.add(p);
		}
			}
			message = "Products Rs 10,000 - Rs 30,000";
		} else if (priceFilter.equals("30000-50000")) {
			for (ProductBean p : products) {
		if (p.getProdPrice() > 30000 && p.getProdPrice() <= 50000) {
			filteredProducts.add(p);
		}
			}
			message = "Products Rs 30,000 - Rs 50,000";
		} else if (priceFilter.equals("50000-100000")) {
			for (ProductBean p : products) {
		if (p.getProdPrice() > 50000 && p.getProdPrice() <= 100000) {
			filteredProducts.add(p);
		}
			}
			message = "Products Rs 50,000 - Rs 1,00,000";
		} else if (priceFilter.equals("100000-200000")) {
			for (ProductBean p : products) {
		if (p.getProdPrice() > 100000 && p.getProdPrice() <= 200000) {
			filteredProducts.add(p);
		}
			}
			message = "Products Rs 1,00,000 - Rs 2,00,000";
		}
		products = filteredProducts;
	} else {
		products = prodDao.getAllProducts();
	}

	if (products.isEmpty()) {
		message = "No items found for the search '"
		+ (search != null ? search : type != null ? type : "selected price range") + "'";
		products = prodDao.getAllProducts();
	}
	%>

	<jsp:include page="header.jsp" />

	<!-- ADDED: Compact Filter Bar -->
	<div class="container-fluid"
		style="background-color: white; border-bottom: 1px solid #ddd; padding: 10px 0; margin-bottom: 15px;">
		<div class="container">
			<div class="row">
				<div class="col-md-12">
					<!-- Filter Dropdown Button -->
					<div class="btn-group" style="margin-right: 15px;">
						<button type="button"
							class="btn btn-default btn-sm dropdown-toggle"
							data-toggle="dropdown"
							style="border: 1px solid #33cc33; color: #33cc33;">
							<i class="glyphicon glyphicon-filter"></i> Price
							<%
							if (priceFilter != null) {
							%>
							<span class="filter-badge">1</span>
							<%
							}
							%>
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu price-filter-menu">
							<li class="dropdown-header">Select Price Range</li>
							<li><a href="userHome.jsp">All Products</a></li>
							<li class="divider"></li>
							<li><a href="userHome.jsp?priceFilter=0-10000">Under Rs
									10,000</a></li>
							<li><a href="userHome.jsp?priceFilter=10000-30000">Rs
									10,000 - Rs 30,000</a></li>
							<li><a href="userHome.jsp?priceFilter=30000-50000">Rs
									30,000 - Rs 50,000</a></li>
							<li><a href="userHome.jsp?priceFilter=50000-100000">Rs
									50,000 - Rs 1,00,000</a></li>
							<li><a href="userHome.jsp?priceFilter=100000-200000">Rs
									1,00,000 - Rs 2,00,000</a></li>
						</ul>
					</div>

					<!-- Active Filter Display -->
					<%
					if (priceFilter != null) {
					%>
					<div class="active-filters"
						style="display: inline-block; margin-right: 15px;">
						<span class="active-filter-tag"> <%
 String filterText = "";
 if (priceFilter.equals("0-10000"))
 	filterText = "Under Rs 10,000";
 else if (priceFilter.equals("10000-30000"))
 	filterText = "Rs 10,000 - Rs 30,000";
 else if (priceFilter.equals("30000-50000"))
 	filterText = "Rs 30,000 - Rs 50,000";
 else if (priceFilter.equals("50000-100000"))
 	filterText = "Rs 50,000 - Rs 1,00,000";
 else if (priceFilter.equals("100000-200000"))
 	filterText = "Rs 1,00,000 - Rs 2,00,000";
 %> <%=filterText%> <a href="userHome.jsp" class="remove-filter">×</a>
						</span>
					</div>
					<%
					}
					%>

					<!-- Results Count -->
					<div class="results-count pull-right"
						style="padding: 6px 0; color: #666; font-size: 13px;">
						<strong><%=products.size()%></strong> products found
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- UPDATED: Product Display Message -->
	<div class="text-center"
		style="color: black; font-size: 16px; font-weight: bold; margin-bottom: 20px;">
		<%=message%>
	</div>

	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">

			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
			%>
			<div class="col-sm-4" style='height: 450px;'>
				<!-- Increased height for wishlist button -->
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px">
					<p class="productname"><%=product.getProdName()%>
					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 100));
					%>
					<p class="productinfo"><%=description%>..
					</p>
					<p class="price">
						Rs
						<%=product.getProdPrice()%>
					</p>

					<%
					// Check if product is in wishlist
					WishlistServiceImpl wishlistService = new WishlistServiceImpl();
					boolean isInWishlist = false;
					try {
						isInWishlist = wishlistService.isInWishlist(userName, product.getProdId());
					} catch (Exception e) {
						// If wishlist service is not available yet, default to false
						isInWishlist = false;
					}
					%>

					<form method="post">
						<%
						if (cartQty == 0) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-success">Add to Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-primary">Buy Now</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
							class="btn btn-danger">Remove From Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit" formaction="cartDetails.jsp"
							class="btn btn-success">Checkout</button>
						<%
						}
						%>
						<br>
						<br>
						<!-- Wishlist Button -->
						<%
						if (isInWishlist) {
						%>
						<button type="submit"
							formaction="./WishlistSrv?action=remove&pid=<%=product.getProdId()%>"
							class="btn btn-warning btn-sm">
							<span class="glyphicon glyphicon-heart"></span> Remove from
							Wishlist
						</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./WishlistSrv?action=add&pid=<%=product.getProdId()%>"
							class="btn btn-info btn-sm">
							<span class="glyphicon glyphicon-heart-empty"></span> Add to
							Wishlist
						</button>
						<%
						}
						%>
					</form>
					<br />
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	<!-- End of Product Items List -->

	<%@ include file="footer.html"%>

</body>
</html>
