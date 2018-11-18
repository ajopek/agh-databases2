namespace bazy_aj.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class cartapp : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Customers",
                c => new
                    {
                        CompanyName = c.String(nullable: false, maxLength: 128),
                        Description = c.String(),
                    })
                .PrimaryKey(t => t.CompanyName);
            
            CreateTable(
                "dbo.Orders",
                c => new
                    {
                        OrderID = c.Int(nullable: false, identity: true),
                        CustomerCompanyName = c.String(maxLength: 128),
                    })
                .PrimaryKey(t => t.OrderID)
                .ForeignKey("dbo.Customers", t => t.CustomerCompanyName)
                .Index(t => t.CustomerCompanyName);
            
            CreateTable(
                "dbo.ProductOrders",
                c => new
                    {
                        OrderID = c.Int(nullable: false),
                        ProductID = c.Int(nullable: false),
                        Quantity = c.Int(nullable: false),
                        UnitPrice = c.Decimal(nullable: false, storeType: "money"),
                    })
                .PrimaryKey(t => new { t.OrderID, t.ProductID })
                .ForeignKey("dbo.Orders", t => t.OrderID, cascadeDelete: true)
                .ForeignKey("dbo.Products", t => t.ProductID, cascadeDelete: true)
                .Index(t => t.OrderID)
                .Index(t => t.ProductID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Orders", "CustomerCompanyName", "dbo.Customers");
            DropForeignKey("dbo.ProductOrders", "ProductID", "dbo.Products");
            DropForeignKey("dbo.ProductOrders", "OrderID", "dbo.Orders");
            DropIndex("dbo.ProductOrders", new[] { "ProductID" });
            DropIndex("dbo.ProductOrders", new[] { "OrderID" });
            DropIndex("dbo.Orders", new[] { "CustomerCompanyName" });
            DropTable("dbo.ProductOrders");
            DropTable("dbo.Orders");
            DropTable("dbo.Customers");
        }
    }
}
