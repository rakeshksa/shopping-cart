package com.shashi.srv;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

/**
 * Servlet implementation class LoginSrv
 */
@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public LoginSrv() {
		super();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userName = request.getParameter("username");
		String password = request.getParameter("password");
		String userType = request.getParameter("usertype");
		
		response.setContentType("text/html");
		String status = "Login Denied! Invalid Username or password.";
		
		// ✅ NULL-SAFE CHECK - This fixes the NullPointerException
		if (userType == null) {
			RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Please select user type!");
			rd.forward(request, response);
			return;
		}
		
		if (userName == null || password == null) {
			RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Please fill all fields!");
			rd.forward(request, response);
			return;
		}
		
		if ("admin".equals(userType)) { // ✅ FIXED: null-safe comparison
			// Login as Admin
			if ("admin".equals(password) && "admin@gmail.com".equals(userName)) {
				// Valid admin
				RequestDispatcher rd = request.getRequestDispatcher("adminViewProduct.jsp");
				HttpSession session = request.getSession();
				session.setAttribute("username", userName);
				session.setAttribute("password", password);
				session.setAttribute("usertype", userType);
				rd.forward(request, response);
			} else {
				// Invalid admin credentials
				RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
				rd.include(request, response);
			}
		} else if ("customer".equals(userType)) { // ✅ FIXED: null-safe comparison
			// Login as customer
			UserServiceImpl udao = new UserServiceImpl();
			status = udao.isValidCredential(userName, password);
			
			if ("valid".equalsIgnoreCase(status)) {
				// Valid customer
				UserBean user = udao.getUserDetails(userName, password);
				HttpSession session = request.getSession();
				session.setAttribute("userdata", user);
				session.setAttribute("username", userName);
				session.setAttribute("password", password);
				session.setAttribute("usertype", userType);
				RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");
				rd.forward(request, response);
			} else {
				// Invalid customer credentials
				RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
				rd.forward(request, response);
			}
		} else {
			// ✅ ADDED: Handle invalid user type
			RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Invalid user type selected!");
			rd.forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
