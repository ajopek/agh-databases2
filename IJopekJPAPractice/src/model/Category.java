package model;

import javax.persistence.*;
import javax.print.attribute.standard.MediaSize;
import java.util.LinkedList;
import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    int CategoryID;


    public String Name;

    @OneToMany(mappedBy = "category")
    List<Product> Products;

    public Category(){};

    public Category(String Name) {
        this.Name = Name;
        this.Products = new LinkedList<>();
    }

    public void addProduct(Product p){
        this.Products.add(p);
        p.setCategory(this);
    }

    public List<Product> getProducts() {
        return Products;
    }
}
