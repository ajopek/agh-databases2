using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace bazy_aj
{
    class Program
    {
        static void Main(string[] args)
        {
            var context = new ProdContext();
            /*Console.WriteLine("Podaj nazwe kategorii");
            var CategoryName = Console.ReadLine();
            var NewCategory = new Category();
            NewCategory.Name = CategoryName;
            context.Categories.Add(NewCategory);
            context.SaveChanges();

            IQueryable<string> query = from c in context.Categories
                                       orderby c.Name descending
                                       select c.Name;

            Console.WriteLine("Kategorie");
            foreach (var name in query)
            {
                Console.WriteLine(name);
            }*/
            //showCategories(context);
            //showCategoriesWithProducts(context);
            countProductsinCategories(context);
            Application.Run(new CategoryForm());
        }

        private static void showCategories(ProdContext context)
        {
            foreach(var name in context.Categories.Include(cat => cat.Name).OrderBy(cat => cat.CategoryID).Select(cat => cat.Name))
            {
                Console.WriteLine(name);
            }
        }

        private static void showCategoriesWithProducts(ProdContext context)
        {
            var join_using_method =
                context.Products.Join(context.Categories,
                    prod => prod.CategoryID, cat => cat.CategoryID,
                    (prod, cat) => new { Category = cat, Product = prod });
            
            var join_using_query = from prod in context.Products
                                   join cat in context.Categories on prod.CategoryID equals cat.CategoryID
                                   select new { Category = cat, Product = prod };
            
            var nav_using_method = 
                context.Products.Select(prod => new { Product = prod, Category = prod.category });

            var nav_using_query =
                from prod in context.Products
                select new { Category = prod.category, Product = prod };

            var eager_using_method =
                context.Categories.Include(cat => cat.Products)
                    .Join(context.Products, cat => cat.CategoryID,
                          prod => prod.CategoryID,
                          (cat, prod) => new { Category = cat, Product = prod });

            var eager_using_query = 
                    from prod in context.Products.Include(p => p.category)
                    select new { Category = prod.category, Product = prod };

            Console.WriteLine("join method");
            foreach (var a in join_using_method)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
            Console.WriteLine("join query");
            foreach (var a in join_using_query)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
            Console.WriteLine("nav method");
            foreach (var a in nav_using_method)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
            Console.WriteLine("nav query");
            foreach (var a in nav_using_query)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
            Console.WriteLine("eager method");
            foreach (var a in eager_using_method)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
            Console.WriteLine("eager query");
            foreach (var a in eager_using_query)
            {
                Console.WriteLine(a.Category.Name + " " + a.Product.Name);
            }
        }

        private static void countProductsinCategories(ProdContext context) 
        {
            var count_using_method = context.Categories
                .Select(c =>
                        new
                        {
                            Name = c.Name,
                            Count = c.Products.Count()
                        }
                       );
            var count_using_query = from c in context.Categories
                select new
                        {
                            Name = c.Name,
                            Count = c.Products.Count()
                        };

            foreach (var result in count_using_method)
            {
                Console.WriteLine(result.Name + " " + result.Count);
            }

            foreach (var result in count_using_query)
            {
                Console.WriteLine(result.Name + " " + result.Count);
            }

        }

    }

    class Product 
    {
        public int ProductID{get; set;}
        public String Name{get; set;}
        public int UnitsInStock { get; set; }
        public int CategoryID { get; set; }
        public Category category { get; set; }
        [Column(TypeName="Money")]
        public decimal Unitprice { get; set; }
    }

    class Category
    {
        public int CategoryID { get; set; }
        public String Name { get; set; }
        public String Description { get; set; }
        public List<Product> Products { get; set; }
    }

    class ProdContext : DbContext
    {
        public DbSet<Category> Categories { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<ProductOrder> ProductOrders { get; set; }
    }

    class Customer 
    {
        [Key]
        public string CompanyName { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            return this.CompanyName;
        }
    }

    class ProductOrder
    {   
        [Key, Column(Order = 1)]
        public int OrderID { get; set; }
        [Key, Column(Order = 2)]
        public int ProductID { get; set; }

        public Order Order { get; set; }
        public Product Product { get; set; }
        
        public int Quantity { get; set; }
        [Column(TypeName = "Money")]
        public decimal UnitPrice { get; set; }

        public override string ToString()
        {   
            return this.Product.Name + " x " + this.Quantity + " price: " + (this.Quantity * this.UnitPrice);
        }
    }

    class Order
    {
        public int OrderID { get; set; }
        public string CustomerCompanyName { get; set; }
        public Customer Customer { get; set; }
        public List<ProductOrder> Content { get; set; }

        public override string ToString()
        {
            return "OrderId: " + this.OrderID + " by " + this.CustomerCompanyName;
        }
    }
}
