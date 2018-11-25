import model.Category;
import model.Invoice;
import model.Product;
import model.Supplier;
import org.hibernate.*;
import org.hibernate.query.Query;
import org.hibernate.cfg.Configuration;

import javax.persistence.metamodel.EntityType;

import java.util.Scanner;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) throws Exception {
        final Session session = getSession();
        try {
            Transaction tx = session.beginTransaction();
            Supplier sup = new Supplier("comarch", "asd 123", "Krakow");
            session.save(sup);
            Product prod1 = new Product("asd1", 1);
            Product prod2 = new Product("asd2", 2);
            Product prod3 = new Product("asd3", 3);
            session.save(prod1);
            session.save(prod2);
            session.save(prod3);
            Invoice trans1 = new Invoice(1);
            Invoice trans2 = new Invoice(2);
            session.save(trans1);
            session.save(trans2);
            trans1.addIncludes(prod1);
            trans1.addIncludes(prod2);
            trans2.addIncludes(prod3);
            trans2.addIncludes(prod2);
            tx.commit();

            System.out.println("Trans1 contains:");
            for(Product p:trans1.getIncludes()){
                System.out.println(p.ProductName);
            }

            System.out.println("Prod2 has been sold in:");
            for(Invoice i: prod2.getCanbesoldin()){
                System.out.println(i);
            }

        } finally {
            session.close();
        }
    }
}