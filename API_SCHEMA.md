# 🗄️ Schéma Base de Données & API REST

## 📋 Vue d'ensemble

Ce document décrit la structure de base de données complète pour une implémentation backend avec MongoDB et Express.js.

---

## 📚 Collections MongoDB

### 1️⃣ Collection: `users`

Utilisateurs de l'application.

```javascript
{
  _id: ObjectId("..."),
  userId: "abc123def456",              // ID unique (useId React)
  email: "sarah@example.com",          // Optionnel
  username: "sarah_shopping",          // Optionnel
  createdAt: ISODate("2024-04-12"),
  lastActivityAt: ISODate("2024-04-12"),
  stats: {
    productsSubmitted: 45,
    productsValidated: 78,
    validationAccuracy: 0.94,           // % approuvés confirmés
    totalPoints: 523,
    badge: "Expert ⭐⭐⭐"
  },
  preferences: {
    notifications: true,
    language: "fr",
    theme: "light"
  },
  reputationScore: 95,                 // 0-100
  isBanned: false
}
```

### 2️⃣ Collection: `products_pending`

Données en attente de validation.

```javascript
{
  _id: ObjectId("..."),
  id: 1712345678,                      // Timestamp unique
  name: "Lait 1L Bio",
  category: "Alimentation",
  price: 1.89,
  currency: "EUR",
  store: "Carrefour",
  storeId: ObjectId("..."),            // Ref vers stores
  submittedBy: "abc123",               // Ref vers users
  submittedAt: ISODate("2024-04-12T10:30:00Z"),
  imageUrl: "https://...",             // Photo du produit
  barcode: "3017750060005",            // Code barres
  
  // Validation
  validations: [
    {
      userId: "def456",
      validatedAt: ISODate("2024-04-12T11:00:00Z"),
      approved: true
    },
    {
      userId: "ghi789",
      validatedAt: ISODate("2024-04-12T11:30:00Z"),
      approved: true
    }
  ],
  rejections: [
    {
      userId: "jkl012",
      rejectedAt: ISODate("2024-04-12T14:00:00Z"),
      reason: "Prix incorrect" // Optionnel
    }
  ],
  
  // Métadonnées
  qualityScore: 85,                    // 0-100 (photo, données, etc.)
  flaggedAsAnomalous: false,
  anomalyScore: 0.15,                  // Z-score statistique
  notes: "Prix check en magasin"       // Notes du validateur
}
```

### 3️⃣ Collection: `products_confirmed`

Données validées et confirmées (min 2 validations).

```javascript
{
  _id: ObjectId("..."),
  id: 1712345678,
  name: "Lait 1L Bio",
  category: "Alimentation",
  price: 1.89,
  currency: "EUR",
  store: "Carrefour",
  storeId: ObjectId("..."),
  submittedBy: "abc123",
  submittedAt: ISODate("2024-04-12T10:30:00Z"),
  
  // Validation complète
  validationCount: 2,
  validatedBy: ["def456", "ghi789"],
  confidenceScore: 50,                 // min(100, validations * 25)
  confirmedAt: ISODate("2024-04-12T11:35:00Z"),
  
  // Métadonnées
  sourceType: "community",             // community, api, scraper
  viewCount: 342,                      // Popularité
  usefulCount: 18,                     // "Utile" votes
  lastUpdatedAt: ISODate("2024-04-12"),
  expiresAt: ISODate("2024-07-12"),    // Rafraîchir après 3 mois
  
  // Données enrichies
  imageUrl: "https://...",
  barcode: "3017750060005",
  brand: "Président",
  size: "1L",
  
  // Historique de prix (pour tendances)
  priceHistory: [
    { price: 1.89, date: ISODate("2024-04-12"), store: "Carrefour" },
    { price: 1.75, date: ISODate("2024-04-05"), store: "Carrefour" },
    { price: 1.95, date: ISODate("2024-03-29"), store: "Carrefour" }
  ]
}
```

### 4️⃣ Collection: `stores`

Magasins/Chaînes de distribution.

```javascript
{
  _id: ObjectId("..."),
  storeId: "carrefour_paris",
  name: "Carrefour",
  chainName: "Carrefour",
  type: "hypermarket",                 // hypermarket, supermarket, discount, etc.
  
  // Localisation
  address: "45 Rue de Rivoli, 75004 Paris",
  city: "Paris",
  postalCode: "75004",
  country: "FR",
  coordinates: {
    type: "Point",
    coordinates: [2.3522, 48.8566]     // [longitude, latitude]
  },
  
  // Contact
  phone: "+33 1 23 45 67 89",
  website: "https://carrefour.fr",
  
  // Informations
  openingHours: {
    monday: "09:00-22:00",
    tuesday: "09:00-22:00",
    wednesday: "09:00-22:00",
    thursday: "09:00-22:00",
    friday: "09:00-22:00",
    saturday: "09:00-22:00",
    sunday: "10:00-20:00"
  },
  
  // Stats
  productsCount: 1245,
  averagePrice: 2.50,
  trustScore: 92,
  
  createdAt: ISODate("2024-01-01"),
  updatedAt: ISODate("2024-04-12")
}
```

### 5️⃣ Collection: `categories`

Catégories de produits.

```javascript
{
  _id: ObjectId("..."),
  categoryId: "alimentation",
  name: "Alimentation",
  description: "Produits alimentaires et boissons",
  icon: "🛒",
  color: "#FF6B6B",
  
  // Hiérarchie
  parentCategory: null,                // null si catégorie principale
  subcategories: [
    "alimentation.fruits",
    "alimentation.produits_laitiers",
    "alimentation.viandes"
  ],
  
  // Stats
  productCount: 890,
  averagePrice: 3.50,
  lastUpdated: ISODate("2024-04-12")
}
```

### 6️⃣ Collection: `alerts`

Alertes prix pour utilisateurs.

```javascript
{
  _id: ObjectId("..."),
  alertId: "alert_12345",
  userId: "abc123",
  
  // Critères
  productName: "Lait 1L",
  category: "Alimentation",
  stores: ["Carrefour", "Leclerc", "Intermarché"],
  maxPrice: 1.20,
  minPrice: null,                      // Optionnel
  
  // Configuration
  isActive: true,
  createdAt: ISODate("2024-04-12"),
  expiresAt: ISODate("2024-07-12"),    // 3 mois
  
  // Notifications
  notificationMethod: "email",         // email, push, sms
  lastNotificationAt: ISODate("2024-04-12T15:00:00Z"),
  notificationCount: 3
}
```

### 7️⃣ Collection: `validators`

Statistiques des validateurs pour modération.

```javascript
{
  _id: ObjectId("..."),
  userId: "def456",
  username: "pierre_validator",
  
  // Performance
  totalValidations: 123,
  approvalsCount: 108,
  rejectionsCount: 15,
  approvalRate: 0.87,                  // 87%
  
  // Accuracy
  correctValidations: 105,             // Confirmées par consensus
  accuracyRate: 0.85,                  // 85%
  
  // Temps
  averageValidationTime: 15,           // minutes
  lastValidationAt: ISODate("2024-04-12T15:00:00Z"),
  
  // Réputation
  reputationScore: 92,                 // 0-100
  trustLevel: "high",                  // low, medium, high, expert
  badge: "Expert Validateur ⭐⭐⭐",
  
  // Flags
  isBanned: false,
  bannedReason: null,
  isModerator: false
}
```

### 8️⃣ Collection: `price_history`

Historique complet des prix (pour analytics).

```javascript
{
  _id: ObjectId("..."),
  productName: "Lait 1L",
  store: "Carrefour",
  storeId: ObjectId("..."),
  
  // Données
  price: 1.89,
  currency: "EUR",
  recordedAt: ISODate("2024-04-12T10:30:00Z"),
  
  // Source
  source: "community",                 // community, api, scraper
  sourceId: "1712345678",
  submittedBy: "abc123",
  confidenceScore: 50,
  
  // Calculs
  dayOfWeek: "Friday",
  weekNumber: 15,
  yearMonth: "2024-04"
}
```

---

## 🔗 Relations (Références)

```
users
  ├─→ products_pending.submittedBy
  ├─→ products_pending.validations[].userId
  ├─→ products_confirmed.submittedBy
  └─→ alerts.userId

products_pending ──→ products_confirmed (après validation)

stores
  ├─← products_pending.storeId
  ├─← products_confirmed.storeId
  └─← price_history.storeId

categories
  ├─← products_pending.category
  ├─← products_confirmed.category
  └─← alerts.category
```

---

## 🔍 Indexes (Performance)

```javascript
// Users
db.users.createIndex({ userId: 1 }, { unique: true });
db.users.createIndex({ createdAt: -1 });

// Products Pending
db.products_pending.createIndex({ id: 1 }, { unique: true });
db.products_pending.createIndex({ name: 1, store: 1 });
db.products_pending.createIndex({ category: 1 });
db.products_pending.createIndex({ submittedAt: -1 });
db.products_pending.createIndex({ "validations.userId": 1 });

// Products Confirmed
db.products_confirmed.createIndex({ id: 1 }, { unique: true });
db.products_confirmed.createIndex({ name: 1, store: 1 });
db.products_confirmed.createIndex({ category: 1 });
db.products_confirmed.createIndex({ confidenceScore: -1 });
db.products_confirmed.createIndex({ expiresAt: 1 });

// Stores
db.stores.createIndex({ storeId: 1 }, { unique: true });
db.stores.createIndex({ name: 1 });
db.stores.createIndex({ "coordinates": "2dsphere" });  // Géo

// Price History
db.price_history.createIndex({ productName: 1, store: 1, recordedAt: -1 });
db.price_history.createIndex({ yearMonth: 1, store: 1 });
```

---

## 🔌 API REST Endpoints

### Authentication

```
POST /api/auth/register
{
  email: "user@example.com",
  password: "secure_password"
}
Response: { userId, token, username }

POST /api/auth/login
{
  email: "user@example.com",
  password: "secure_password"
}
Response: { userId, token }

POST /api/auth/logout
Response: { success: true }
```

### Products

```
GET /api/products
Query: ?category=Alimentation&store=Carrefour&limit=50
Response: { products: [...], total: 1200, page: 1 }

GET /api/products/:id
Response: { product: {...} }

GET /api/products/search?q=Lait&category=Alimentation
Response: { results: [...], count: 45 }

POST /api/products (Add)
Body: {
  name: "Lait 1L",
  price: 1.89,
  store: "Carrefour",
  category: "Alimentation",
  imageUrl: "..."
}
Response: { _id, status: "pending", id: 1712345678 }

POST /api/products/:id/validate
Headers: { Authorization: "Bearer token" }
Body: { approved: true, reason: "Verified in store" }
Response: { success: true, confidenceScore: 50 }

POST /api/products/:id/reject
Headers: { Authorization: "Bearer token" }
Body: { reason: "Prix incorrect" }
Response: { success: true }

DELETE /api/products/:id (Admin)
Headers: { Authorization: "Bearer admin_token" }
Response: { success: true }
```

### Stores

```
GET /api/stores
Query: ?city=Paris&type=hypermarket
Response: { stores: [...], total: 25 }

GET /api/stores/:id
Response: { store: {...}, nearbyStores: [...] }

GET /api/stores/nearby?latitude=48.8566&longitude=2.3522&radius=5000
Response: { stores: [...], distances: [...] }

POST /api/stores (Admin)
Body: { name, address, city, country, coordinates }
Response: { _id, storeId }
```

### Comparaison

```
GET /api/compare
Query: ?product=Lait&category=Alimentation
Response: {
  product: "Lait 1L",
  prices: [
    { store: "Carrefour", price: 1.29, confidence: 100 },
    { store: "Leclerc", price: 1.45, confidence: 75 },
    { store: "Intermarché", price: 1.39, confidence: 50 }
  ],
  bestPrice: 1.29,
  savings: [0, 0.16, 0.10],
  average: 1.38
}

GET /api/compare/multiple
Body: { products: ["Lait", "Œufs", "Fromage"] }
Response: { comparisons: [...], totalSavings: 1.25 }
```

### Validations

```
GET /api/pending
Query: ?limit=20&category=Alimentation
Response: { pending: [...], count: 45 }

GET /api/pending/:id
Response: { product: {...}, validationStats: {...} }

POST /api/pending/:id/approve
Headers: { Authorization: "Bearer token" }
Response: { success: true, newConfidenceScore: 75 }

POST /api/pending/:id/reject
Headers: { Authorization: "Bearer token" }
Body: { reason: "Données incorrectes" }
Response: { success: true }

GET /api/my-validations
Headers: { Authorization: "Bearer token" }
Response: { validations: [...], stats: { approved: 10, rejected: 2 } }
```

### Alertes

```
GET /api/alerts (Mes alertes)
Headers: { Authorization: "Bearer token" }
Response: { alerts: [...] }

POST /api/alerts (Créer)
Headers: { Authorization: "Bearer token" }
Body: {
  productName: "Lait",
  maxPrice: 1.20,
  stores: ["Carrefour", "Leclerc"],
  expiresAt: "2024-07-12"
}
Response: { _id, alertId }

DELETE /api/alerts/:id
Headers: { Authorization: "Bearer token" }
Response: { success: true }

POST /api/alerts/:id/pause
Response: { success: true, status: "paused" }
```

### Analytics

```
GET /api/analytics/stats
Response: {
  totalProducts: 2450,
  totalValidations: 4890,
  averageConfidence: 73,
  topCategories: [...],
  topStores: [...],
  totalSavings: 1245.50
}

GET /api/analytics/user-stats
Headers: { Authorization: "Bearer token" }
Response: {
  userId: "abc123",
  productsSubmitted: 45,
  validationsCount: 78,
  accuracyRate: 94,
  points: 523,
  badge: "Expert ⭐⭐⭐"
}

GET /api/analytics/price-trends
Query: ?product=Lait&days=30
Response: {
  product: "Lait",
  dates: ["2024-03-12", ...],
  prices: [1.29, 1.31, 1.30, ...],
  trend: "stable",
  priceChange: "+0.01€"
}
```

### Validation Stats

```
GET /api/validators/:userId
Response: {
  userId: "def456",
  totalValidations: 123,
  accuracyRate: 85,
  reputationScore: 92,
  trustLevel: "high",
  badge: "Expert Validateur"
}

GET /api/validators/leaderboard
Query: ?limit=10&period=month
Response: {
  leaderboard: [
    { rank: 1, userId, validations: 42, accuracy: 95 },
    ...
  ]
}
```

---

## 🛡️ Authentification

### JWT Token
```javascript
Header: {
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

Token Payload: {
  userId: "abc123",
  email: "user@example.com",
  iat: 1712345678,
  exp: 1712432078      // 24h expiration
}
```

### Permissions
```
- Public: GET products, GET stores, GET compare
- User: POST products, POST validations, GET alerts
- Moderator: PATCH products, DELETE posts
- Admin: All operations
```

---

## 💾 Variables d'environnement

```env
# Server
PORT=5000
NODE_ENV=production

# Database
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/price-comparison
MONGODB_DB=price-comparison

# Authentication
JWT_SECRET=your_super_secret_key_12345
JWT_EXPIRATION=24h

# API Keys
GOOGLE_MAPS_API_KEY=...
BARCODE_API_KEY=...
SMTP_PASSWORD=...

# Notifications
SENDGRID_API_KEY=...
FIREBASE_PROJECT_ID=...

# Features
ENABLE_NOTIFICATIONS=true
ENABLE_BARCODE_SCANNING=true
ENABLE_GEOLOCATION=true
```

---

## 📊 Requêtes Utiles (Aggregation)

### Prix moyens par catégorie

```javascript
db.products_confirmed.aggregate([
  { $match: { validationCount: { $gte: 2 } } },
  { $group: {
    _id: "$category",
    avgPrice: { $avg: "$price" },
    minPrice: { $min: "$price" },
    maxPrice: { $max: "$price" },
    count: { $sum: 1 }
  }},
  { $sort: { count: -1 } }
])
```

### Meilleurs validateurs

```javascript
db.validators.aggregate([
  { $match: { isBanned: false } },
  { $sort: { accuracyRate: -1, totalValidations: -1 } },
  { $limit: 10 },
  { $project: { userId: 1, accuracyRate: 1, totalValidations: 1, badge: 1 } }
])
```

### Tendance de prix

```javascript
db.price_history.aggregate([
  { $match: { productName: "Lait 1L", store: "Carrefour" } },
  { $sort: { recordedAt: 1 } },
  { $group: {
    _id: "$yearMonth",
    avgPrice: { $avg: "$price" },
    records: { $sum: 1 }
  }},
  { $sort: { _id: 1 } }
])
```

---

## 🚀 Déploiement Recommandé

```
Frontend (React)
   ↓
Vercel / Netlify
   ↓
Backend (Express.js)
   ↓
Heroku / Railway / Render
   ↓
Database (MongoDB Atlas)
   ↓
CDN (Cloudinary pour images)
```

---

C'est tout! La base de données et l'API sont maintenant prêtes pour implémentation. 🚀