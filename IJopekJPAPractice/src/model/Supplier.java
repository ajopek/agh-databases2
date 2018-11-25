package model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int suppId;

    public String CompanyName;
    public String Street;
    public String City;

    @OneToMany(mappedBy = "supplier")
    private Set<Product> supplies;

    public void addProduct(Product p) {
        supplies.add(p);
        p.setSupplier(this);
    }

    public Supplier(){}
    public Supplier(String companyName, String street, String city){
        supplies = new HashSet<>();
        this.City = city;
        this.CompanyName = companyName;
        this.Street = street;
    }
}
