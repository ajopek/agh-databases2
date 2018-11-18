namespace bazy_aj.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Money : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Products", "UnitsInStock", c => c.Int(nullable: false));
            AddColumn("dbo.Products", "CategoryID", c => c.Int(nullable: false));
            AddColumn("dbo.Products", "Unitprice", c => c.Decimal(nullable: false, storeType: "money"));
            CreateIndex("dbo.Products", "CategoryID");
            AddForeignKey("dbo.Products", "CategoryID", "dbo.Categories", "CategoryID", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Products", "CategoryID", "dbo.Categories");
            DropIndex("dbo.Products", new[] { "CategoryID" });
            DropColumn("dbo.Products", "Unitprice");
            DropColumn("dbo.Products", "CategoryID");
            DropColumn("dbo.Products", "UnitsInStock");
        }
    }
}
