package com.shashi.beans;

import java.io.Serializable;
import java.sql.Timestamp;

public class WishlistBean implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String email;
    private String prodId;
    private Timestamp addedDate;
    
    public WishlistBean() {
    }
    
    public WishlistBean(String email, String prodId) {
        this.email = email;
        this.prodId = prodId;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getProdId() {
        return prodId;
    }
    
    public void setProdId(String prodId) {
        this.prodId = prodId;
    }
    
    public Timestamp getAddedDate() {
        return addedDate;
    }
    
    public void setAddedDate(Timestamp addedDate) {
        this.addedDate = addedDate;
    }
    
    @Override
    public String toString() {
        return "WishlistBean [email=" + email + ", prodId=" + prodId + ", addedDate=" + addedDate + "]";
    }
}
