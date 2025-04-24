# E-Commerce Database Documentation

## Overview

This database schema provides a comprehensive structure for managing an e-commerce platform, including products, variations, categories, attributes, and inventory management.

## Database Schema

### Core Tables

1. **brand** - Stores brand information
   * `brand_id`: Primary key
   * `brand_name`: Unique brand identifier
   * `logo_url`: Path to brand logo
2. **product_category** - Hierarchical product categorization
   * Supports parent-child relationships
   * Self-referencing foreign key for hierarchy
3. **product** - Main product information
   * Links to brand and category
   * Contains base pricing and descriptions

### Inventory Management

4. **product_item** - Specific product variations
   * Tracks inventory (quantity_in_stock)
   * Contains SKU information
   * Links to parent product
5. **product_variation** - Connects items with size/color
   * Many-to-many relationship between items and variations
   * Uses size_option and color tables

### Variation System

6. **color** - Available color options
   * Includes color codes (hex values)
7. **size_category** - Groups sizes by type (clothing, shoes)
8. **size_option** - Specific size options within categories

### Media Management

9. **product_image** - Product photography
   * Supports multiple images per product/item
   * Flags for primary image
   * Display ordering

### Attribute System

10. **attribute_category** - Groups attributes (Physical, Technical)
11. **attribute_type** - Data types for attributes (Text, Number, Boolean)
12. **product_attribute** - Custom product specifications
    * Flexible key-value storage
    * Type validation through attribute_type

## Sample Data

The database includes sample data for:

* 3 brands (Nike, Samsung, IKEA)
* 6 product categories in hierarchical structure
* 4 colors and 6 size options
* 3 products with 6 total variations
* Product images and attributes

## Key Relationships

1. **Product Hierarchy** :

* Product → Brand (many-to-one)
* Product → Category (many-to-one)
* Category → Parent Category (self-referencing)

1. **Inventory Management** :

* Product → Product Items (one-to-many)
* Product Item → Variations (one-to-many)

1. **Attribute System** :

* Product → Attributes (one-to-many)
* Attribute → Category/Type (many-to-one)

This database provides a solid foundation for an e-commerce platform with flexible product variations and attributes.

The [ERD image](\Images\E-commerce Database ERD.jpg) can be found in the images folder that shows the entiry relationship between the tables, which was curated using Draw.io.
