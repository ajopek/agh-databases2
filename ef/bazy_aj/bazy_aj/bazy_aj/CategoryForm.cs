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
    public partial class CategoryForm : Form
    {
        ProdContext context;
        int currentlySelectedCategoryID = -1;
        List<Product> products;
        public CategoryForm()
        {
            InitializeComponent();
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            context = new ProdContext();
            context.Categories.Load();
            this.categoryBindingSource.DataSource = context.Categories.Local.ToBindingList();
            this.bindingNavigator1.BindingSource = this.categoryBindingSource;

            this.dataGridView1.CellClick += new DataGridViewCellEventHandler(this.categoryClick);
        }

        private void categoryClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= context.Categories.Local.Count) return;
            int catID = context.Categories.Local[e.RowIndex].CategoryID;
            if (catID == currentlySelectedCategoryID) return;
            updateProductsList(catID);
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

        private void saveToolStripButton_Click(object sender, EventArgs e)
        {
            if (currentlySelectedCategoryID != -1)
            {
                int inDBProductsCount = context.Products.Where(p => p.CategoryID == currentlySelectedCategoryID).Count();
                for (int i = inDBProductsCount; i < dataGridView2.Rows.Count; i++)
                {
                    var values = dataGridView2.Rows[i].Cells;
                    if (values[1].Value != null)
                    {
                        var p = new Product();
                        p.Name = values[1].Value.ToString();
                        p.CategoryID = currentlySelectedCategoryID;
                        p.Unitprice = values[4] == null ? 0 : Decimal.Parse(values[4].Value.ToString());
                        p.UnitsInStock = values[2] == null ? 0 : Int32.Parse(values[2].Value.ToString());
                        this.context.Products.Add(p);
                    }
                }
                this.Validate();
                this.context.SaveChanges();
                this.dataGridView1.Refresh();
                this.dataGridView2.Refresh();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Product p = new Product();
            p.CategoryID = currentlySelectedCategoryID;
            products.Add(p);
            this.dataGridView2.DataSource = products; 
            this.dataGridView2.Refresh();
        }
    }
}
