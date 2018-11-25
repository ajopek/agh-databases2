package model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name="Products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int productId;

    public String ProductName;
    public int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name="SUPPLIER_FK")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name="CATEGORY_FK")
    private Category category;

    @ManyToMany(mappedBy = "includes")
    private Set<Invoice> canbesoldin;

    public Product(){}

    public Product(String productName,  int unitsOnStock) {
        this.ProductName = productName;
        this.UnitsOnStock = unitsOnStock;
        this.canbesoldin = new HashSet<>();
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public void setCategory(Category c) {
        this.category = c;
    }

    public Category getCategory() {
        return category;
    }
    public void addCanBeSoldIn(Invoice i) {
        this.canbesoldin.add(i);
    }

    public Set<Invoice> getCanbesoldin() {
        return canbesoldin;
    }
}
