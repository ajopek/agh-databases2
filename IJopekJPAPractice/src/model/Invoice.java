package model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int InvoiceNumber;

    public int quantity;

    @ManyToMany
    private Set<Product> includes;

    public Invoice(){}
    public Invoice(int quntity){
        this.quantity = quntity;
        this.includes = new HashSet<>();
    }

    public void addIncludes(Product p) {
        this.includes.add(p);
        p.addCanBeSoldIn(this);
    }

    public Set<Product> getIncludes() {
        return includes;
    }
}
