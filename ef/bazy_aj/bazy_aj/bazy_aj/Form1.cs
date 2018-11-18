using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Entity;

namespace bazy_aj
{   
    public partial class Form1 : Form
    {
        ProdContext context;
        int currentlySelectedCategoryID = -1;
        Product currentlySelectedProduct = null;
        BindingList<CartItem> cart = new BindingList<CartItem>();
        List<Product> products;
        Customer selectedCustomer;
        Order selectedOrder;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.productsTableAdapter.Fill(this._bazy_aj_ProdContextDataSet.Products);
            this.categoriesTableAdapter.Fill(this._bazy_aj_ProdContextDataSet.Categories);

        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            context = new ProdContext();
            context.Categories.Load();
            context.Customers.Load();
            context.Orders.Include(o => o.Content.Select(po => po.Product)).Load();
            
            this.categoriesBindingSource.DataSource = context.Categories.Local.ToBindingList();
            this.CustomerName.DataSource = context.Customers.Local.ToBindingList();
            this.OrdersList.DataSource = context.Orders.Local.ToBindingList();

            this.dataGridView1.CellClick += new DataGridViewCellEventHandler(this.categoryClick);
            this.dataGridView2.CellClick += new DataGridViewCellEventHandler(this.productClick);
            
            this.CartList.DataSource = cart;
            this.selectedCustomer = context.Customers.Local.First();
            this.selectedOrder = context.Orders.Local.First();
            this.OrderContent.DataSource = selectedOrder.Content;
            CalculateOrderTotal();
        }

        private void CalculateOrderTotal()
        {
            this.OrderTotal.Text = selectedOrder.Content.Sum(po => po.Quantity * po.UnitPrice).ToString();
            this.OrderTotal.Refresh();
        }

        private void categoryClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= context.Categories.Local.Count) return;
            int catID = context.Categories.Local[e.RowIndex].CategoryID;
            if (catID == currentlySelectedCategoryID) return;
            updateProductsList(catID);
        }

        private void productClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex > products.Count()) return;
            currentlySelectedProduct = products[e.RowIndex];
            this.ProductNameBox.Text = currentlySelectedProduct.Name;
            decimal quantityInCart =
                cart.Where(i => i.product.ProductID == currentlySelectedProduct.ProductID).Sum(i => i.quantity);
            this.Quantity.Maximum = currentlySelectedProduct.UnitsInStock - quantityInCart;
            this.ProductNameBox.Refresh();
            this.Quantity.Refresh();
        }

        private void updateProductsList(int categoryID)
        {
            currentlySelectedCategoryID = categoryID;
            // Wersja 1
            IQueryable<Product> query = from p in context.Products
                                        where (p.CategoryID == categoryID)
                                        select p;
            // Wersja 2
            var query2 = context.Products.Where(p => p.CategoryID == categoryID);
            products = query.ToList();
            this.dataGridView2.DataSource = query.ToList();
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            base.OnClosing(e);
            this.context.Dispose();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (currentlySelectedProduct != null) {
                
                CartItem item = new CartItem();
                item.product = currentlySelectedProduct;
                item.quantity = decimal.ToInt32(this.Quantity.Value);

                var alreadyInCart = from i in cart
                                     where i.product.ProductID == item.product.ProductID
                                     select i;
                if (alreadyInCart.Count() > 0)
                {
                    foreach (var i in alreadyInCart) 
                    {
                        item.quantity += i.quantity;
                        cart.Remove(i);
                    }
                }

                cart.Add(item);
                RecalculateValue();
                this.CartList.Refresh();
            }
        }

        private void ClearCart()
        {
            cart.Clear();
        }

        private void RecalculateValue()
        {
            this.TotalValue.Text = cart.Sum(cp => cp.product.Unitprice * cp.quantity).ToString();
            this.TotalValue.Refresh();
        }

        private void Order() 
        {
            if (cart.Count() == 0)
            {
                Console.WriteLine("Your cart is empty");
                return;
            }

            Order order = new Order();
            order.CustomerCompanyName = selectedCustomer.CompanyName;
            context.Orders.Add(order);
            context.SaveChanges();

            foreach(var i in cart)
            {
                context.ProductOrders.Add(
                    new ProductOrder { 
                        ProductID = i.product.ProductID,
                        OrderID = order.OrderID,
                        Quantity = i.quantity,
                        UnitPrice = i.product.Unitprice,
                    }
                );
                var prod = context.Products.Where(p => p.ProductID == i.product.ProductID).First();
                prod.UnitsInStock -= i.quantity;
            }

            context.SaveChanges();
            ClearCart();
            this.Refresh();
        }

        private void ClearButton_Click(object sender, EventArgs e)
        {
            ClearCart();
        }

        private void OrderButton_Click(object sender, EventArgs e)
        {
            Order();
        }

        private void CustomerName_SelectedIndexChanged(object sender, EventArgs e)
        {
            selectedCustomer = context.Customers.Local[this.CustomerName.SelectedIndex];
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void OrdersList_SelectedIndexChanged(object sender, EventArgs e)
        {
            selectedOrder = context.Orders.Local[this.OrdersList.SelectedIndex];
            this.OrderContent.DataSource = selectedOrder.Content;
            CalculateOrderTotal();
            this.OrderContent.Refresh();
        }
    }

    class CartItem
    {
        public Product product;
        public int quantity;

        public override string ToString()
        {
            return quantity.ToString() + "x " + product.Name + ", price: " + (product.Unitprice * quantity).ToString(); 
        }
    }

}
