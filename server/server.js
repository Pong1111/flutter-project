const express = require('express');
const cors = require('cors');
const WebSocket = require('ws');
const app = express();
const server = require('http').createServer(app);
const wss = new WebSocket.Server({ server });

app.use(cors());
app.use(express.json());
app.use('/assets', express.static('../assets'));

// Store connected clients for SSE
const clients = new Set();

// SSE endpoint for real-time updates
app.get('/api/updates', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  
  // Send initial data
  res.write(`data: ${JSON.stringify(shoes)}\n\n`);
  
  // Add client to the set
  clients.add(res);
  
  // Remove client when connection closes
  req.on('close', () => {
    clients.delete(res);
  });
});

// Function to broadcast updates to all clients
function broadcastUpdate() {
  const data = JSON.stringify(shoes);
  clients.forEach(client => {
    client.write(`data: ${data}\n\n`);
  });
}

// Sample data
const shoes = [
  {
    id: '1',
    name: 'Air Max Classic',
    brand: 'Nike',
    colorway: 'White/Black-Red',
    price: 9999,
    description: 'Classic Nike Air Max design with modern comfort technology.',
    images: ['assets/images/airmax_classic.jpg'],
    sku: 'NK-AM-001',
    inStock: true
  },
  {
    id: '2',
    name: 'Ultra Boost Premium',
    brand: 'Adidas',
    colorway: 'Core Black/White',
    price: 179.99,
    description: 'Premium running shoes with responsive Boost cushioning.',
    images: ['assets/images/UltraBoost_Premium.jpeg'],
    sku: 'AD-UB-001',
    inStock: true
  },
  {
    id: '3',
    name: 'Classic Leather',
    brand: 'Reebok',
    colorway: 'White/Gum',
    price: 74.99,
    description: 'Timeless design with premium leather upper.',
    images: ['assets/images/Classic_Leather.webp'],
    sku: 'RB-CL-001',
    inStock: true
  },
  {
    id: '4',
    name: 'Jordan Retro 1',
    brand: 'Nike',
    colorway: 'University Blue/White',
    price: 169.99,
    description: 'Iconic basketball sneaker with premium materials and classic styling.',
    images: ['assets/images/1.jpeg'],
    sku: 'NK-AJ-001',
    inStock: true
  },
  {
    id: '5',
    name: 'NMD R1',
    brand: 'Adidas',
    colorway: 'Grey/Solar Red',
    price: 139.99,
    description: 'Modern streetwear sneaker with Boost technology and sock-like fit.',
    images: ['assets/images/2.jpeg'],
    sku: 'AD-NMD-001',
    inStock: true
  },
  {
    id: '6',
    name: 'Gel-Kayano 29',
    brand: 'ASICS',
    colorway: 'Black/Safety Yellow',
    price: 159.99,
    description: 'Premium running shoe with GEL cushioning and stability features.',
    images: ['assets/images/3.jpeg'],
    sku: 'AS-GK-001',
    inStock: true
  },
  {
    id: '7',
    name: 'Chuck 70 Hi',
    brand: 'Converse',
    colorway: 'Parchment/Garnet',
    price: 84.99,
    description: 'Premium version of the classic Chuck Taylor with enhanced materials.',
    images: ['assets/images/4.jpeg'],
    sku: 'CV-70-001',
    inStock: true
  },
  {
    id: '8',
    name: 'Suede Classic',
    brand: 'Puma',
    colorway: 'Peacoat/White',
    price: 69.99,
    description: 'Timeless street style with premium suede upper and classic design.',
    images: ['assets/images/5.jpeg'],
    sku: 'PM-SC-001',
    inStock: true
  },
  {
    id: '9',
    name: 'Fresh Foam 1080v12',
    brand: 'New Balance',
    colorway: 'Thunder/Black',
    price: 159.99,
    description: 'Premium running shoe with Fresh Foam X cushioning for maximum comfort.',
    images: ['assets/images/6.jpeg'],
    sku: 'NB-FF-001',
    inStock: true
  }
];

// WebSocket connection handler
wss.on('connection', (ws) => {
  console.log('Client connected');
  // Send initial data
  ws.send(JSON.stringify({ type: 'update', data: shoes }));
  
  ws.on('close', () => {
    console.log('Client disconnected');
  });
});

// Get all shoes
app.get('/api/shoes', (req, res) => {
  const { keyword } = req.query;
  if (keyword) {
    const filtered = shoes.filter(shoe => 
      shoe.name.toLowerCase().includes(keyword.toLowerCase()) ||
      shoe.brand.toLowerCase().includes(keyword.toLowerCase())
    );
    res.json(filtered);
  } else {
    res.json(shoes);
  }
});

// Update shoe stock
app.post('/api/shoes/:id/stock', (req, res) => {
  const { id } = req.params;
  const { inStock } = req.body;
  
  const shoe = shoes.find(s => s.id === id);
  if (shoe) {
    shoe.inStock = inStock;
    broadcastUpdate();
    res.json(shoe);
  } else {
    res.status(404).json({ error: 'Shoe not found' });
  }
});

// Update shoe price
app.post('/api/shoes/:id/price', (req, res) => {
  const { id } = req.params;
  const { price } = req.body;
  
  const shoe = shoes.find(s => s.id === id);
  if (shoe) {
    shoe.price = price;
    broadcastUpdate();
    res.json(shoe);
  } else {
    res.status(404).json({ error: 'Shoe not found' });
  }
});

// Get shoe by ID
app.get('/api/shoes/:id', (req, res) => {
  const shoe = shoes.find(s => s.id === req.params.id);
  if (shoe) {
    res.json(shoe);
  } else {
    res.status(404).json({ error: 'Shoe not found' });
  }
});

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`WebSocket server is running on ws://localhost:${PORT}`);
});