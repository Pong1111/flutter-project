const fs = require('fs');

// Function to create a simple placeholder image (just a text file for now)
function createPlaceholderImage(filename, description) {
  fs.writeFileSync(
    `uploads/${filename}`, 
    `This is a placeholder for: ${description}\nIn a real app, this would be an actual image file.`
  );
}

// Create placeholder images for all shoes
createPlaceholderImage('shoe1-1.jpg', 'Nike Air Max Classic - Front View');
createPlaceholderImage('shoe1-2.jpg', 'Nike Air Max Classic - Side View');
createPlaceholderImage('shoe2-1.jpg', 'Adidas Ultra Boost - Front View');
createPlaceholderImage('shoe2-2.jpg', 'Adidas Ultra Boost - Side View');
createPlaceholderImage('shoe3-1.jpg', 'Reebok Classic Leather - Front View');
createPlaceholderImage('shoe3-2.jpg', 'Reebok Classic Leather - Side View');

console.log('Created placeholder images');