-- Create eccomerce database for use
CREATE DATABASE ecommerce;
USE ecommerce;

-- code for brand table creation
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (brand_name)
);

-- code for product category table with self-referencing relationship for hierarchical categories
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    parent_category_id INT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id) ON DELETE SET NULL,
    UNIQUE (category_name)
);

-- code for product table with core product information
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT,
    category_id INT,
    product_name VARCHAR(255) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE SET NULL,
    INDEX idx_product_active (active),
    INDEX idx_product_brand (brand_id),
    INDEX idx_product_category (category_id)
);

-- code for product item table with specific purchasable variations of products
CREATE TABLE product_item (
    product_item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    SKU VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    UNIQUE (SKU),
    INDEX idx_product_item_product (product_id),
    INDEX idx_product_item_active (active)
);

-- code for color table creation
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (color_name),
    UNIQUE (color_code)
);

-- code for size category table creation
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (category_name)
);

-- code for size option table creation
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_name VARCHAR(50) NOT NULL,
    size_code VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id) ON DELETE CASCADE,
    UNIQUE KEY unique_size_in_category (size_category_id, size_name),
    INDEX idx_size_option_category (size_category_id)
);

-- code for product variation table that connects product items with specific color and size
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_item_id INT NOT NULL,
    size_id INT,
    color_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_item_id) REFERENCES product_item(product_item_id) ON DELETE CASCADE,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL,
    UNIQUE KEY unique_product_variation (product_item_id, size_id, color_id),
    INDEX idx_product_variation_size (size_id),
    INDEX idx_product_variation_color (color_id)
);

-- code for product image table creation
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    product_item_id INT,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (product_item_id) REFERENCES product_item(product_item_id) ON DELETE CASCADE,
    INDEX idx_product_image_product (product_id),
    INDEX idx_product_image_product_item (product_item_id),
    INDEX idx_product_image_primary (is_primary)
);

-- code for attribute category table creation
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (category_name)
);

-- code for attribute type table creation
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (type_name)
);

-- code for product attribute table that stores custom attributes for products
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_category_id INT,
    attribute_type_id INT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id) ON DELETE SET NULL,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id) ON DELETE SET NULL,
    INDEX idx_product_attribute_product (product_id),
    INDEX idx_product_attribute_category (attribute_category_id),
    INDEX idx_product_attribute_type (attribute_type_id)
);

-- Insert sample data for testing database
-- sample data for brands
INSERT INTO brand (brand_name, description) VALUES 
('Nike', 'Athletic footwear and apparel'),
('Samsung', 'Electronics and appliances'),
('IKEA', 'Furniture and home goods');

-- sample data for categories
INSERT INTO product_category (category_name, description) VALUES 
('Electronics', 'Electronic devices and accessories');

INSERT INTO product_category (parent_category_id, category_name, description) VALUES 
(1, 'Smartphones', 'Mobile phones and accessories'),
(1, 'Laptops', 'Portable computers');

INSERT INTO product_category (category_name, description) VALUES 
('Clothing', 'Apparel and fashion items');

INSERT INTO product_category (parent_category_id, category_name, description) VALUES 
(4, 'Footwear', 'Shoes, boots, and sandals'),
(4, 'Shirts', 'T-shirts, button-ups, and blouses');

-- sample data for colors
INSERT INTO color (color_name, color_code) VALUES 
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF');

-- sample data for size categories
INSERT INTO size_category (category_name, description) VALUES 
('Clothing Sizes', 'Standard clothing sizes'),
('Shoe Sizes', 'Standard shoe sizes');

-- sample data for size options
INSERT INTO size_option (size_category_id, size_name, size_code) VALUES 
(1, 'Small', 'S'),
(1, 'Medium', 'M'),
(1, 'Large', 'L'),
(2, 'US 8', '8'),
(2, 'US 9', '9'),
(2, 'US 10', '10');

-- sample data for attribute categories
INSERT INTO attribute_category (category_name, description) VALUES 
('Physical', 'Physical characteristics'),
('Technical', 'Technical specifications');

-- sample data for attribute types
INSERT INTO attribute_type (type_name, description) VALUES 
('Text', 'Text values'),
('Number', 'Numeric values'),
('Boolean', 'True/False values');

-- sample data for products
INSERT INTO product (brand_id, category_id, product_name, base_price, description) VALUES 
(1, 5, 'Air Max 270', 150.00, 'Comfortable athletic shoes with visible air cushioning'),
(2, 2, 'Galaxy S23', 999.99, 'Latest flagship smartphone with advanced camera system'),
(3, 4, 'SKOGSTA T-Shirt', 19.99, 'Comfortable cotton t-shirt');

-- sample data for product items
INSERT INTO product_item (product_id, SKU, price, quantity_in_stock) VALUES 
(1, 'AM270-BLK-10', 150.00, 25),
(1, 'AM270-RED-9', 150.00, 15),
(2, 'GS23-BLK-128', 999.99, 50),
(2, 'GS23-WHT-256', 1099.99, 30),
(3, 'SKT-BLU-M', 19.99, 100),
(3, 'SKT-BLU-L', 19.99, 75);

-- sample data for product variations
INSERT INTO product_variation (product_item_id, size_id, color_id) VALUES 
(1, 6, 1),  -- Air Max, Size 10, Black
(2, 5, 3),  -- Air Max, Size 9, Red
(3, NULL, 1),  -- Galaxy S23, Black, 128GB
(4, NULL, 2),  -- Galaxy S23, White, 256GB
(5, 2, 4),  -- T-Shirt, Medium, Blue
(6, 3, 4);  -- T-Shirt, Large, Blue

-- sample data for product images
INSERT INTO product_image (product_id, product_item_id, image_url, is_primary) VALUES 
(1, 1, 'Images\airmax_black_1.jpg', TRUE),
(1, 1, 'Images\airmax_black_2.jpg', FALSE),
(1, 2, 'Images\airmax_red.jpg', TRUE),
(2, 3, 'Images\galaxy_black.jpg', TRUE),
(2, 4, 'Images\galaxy_white.jpg', TRUE),
(3, 5, 'Images\tshirt_blue.jpg', TRUE);

-- sample data for product attributes
INSERT INTO product_attribute (product_id, attribute_category_id, attribute_type_id, attribute_name, attribute_value) VALUES 
(1, 1, 2, 'Weight', '300'),
(1, 1, 1, 'Material', 'Synthetic leather, mesh'),
(2, 2, 2, 'Screen Size', '6.1'),
(2, 2, 2, 'RAM', '8'),
(2, 2, 1, 'Processor', 'Snapdragon 8 Gen 2'),
(3, 1, 1, 'Material', '100% Cotton'),
(3, 1, 3, 'Machine Washable', 'TRUE');
