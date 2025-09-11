package com.shashi.starter;

import java.io.File;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

public class EmbeddedTomcatStarter {
    
    public static void main(String[] args) {
        try {
            Tomcat tomcat = new Tomcat();
            
            // Set port and CREATE the connector - this is crucial!
            tomcat.setPort(8080);
            tomcat.getConnector(); // This line is ESSENTIAL for HTTP requests
            
            // Use existing webapp directory
            String webappDir = "target/classes/webapp";
            File webappDirFile = new File(webappDir);
            
            if (!webappDirFile.exists()) {
                System.err.println("Webapp directory not found: " + webappDir);
                System.exit(1);
            }
            
            // Add webapp with proper context
            Context context = tomcat.addWebapp("/shopping-cart", webappDirFile.getAbsolutePath());
            
            // Configure resources for classes
            File classesDir = new File("target/classes");
            if (classesDir.exists()) {
                StandardRoot resources = new StandardRoot(context);
                resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                        classesDir.getAbsolutePath(), "/"));
                context.setResources(resources);
            }
            
            // Start the server
            tomcat.start();
            
            System.out.println("========================================");
            System.out.println("✅ Shopping Cart Started Successfully!");
            System.out.println("🌐 URL: http://localhost:8080/shopping-cart");
            System.out.println("📁 Webapp: " + webappDirFile.getAbsolutePath());
            System.out.println("🛑 Press Ctrl+C to stop server");
            System.out.println("========================================");
            
            // Keep server running
            tomcat.getServer().await();
            
        } catch (Exception e) {
            System.err.println("❌ Failed to start server: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
