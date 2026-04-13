# 🚀 Guide Installation & Déploiement

## Option 1: Utiliser avec React (Développement)

### Prérequis
- Node.js 14+ installé
- npm ou yarn

### Installation

```bash
# Créer un nouveau projet React
npx create-react-app price-comparison-app
cd price-comparison-app

# Copier le code
cp price_comparison_app.jsx src/App.jsx

# Installer (optionnel) lucide-react pour les icônes
npm install lucide-react

# Lancer en développement
npm start
```

L'app s'ouvre automatiquement à `http://localhost:3000`

---

## Option 2: Utiliser avec Next.js (Production)

```bash
# Créer un projet Next.js
npx create-next-app@latest price-comparison-app

# Copier le code dans app/page.jsx
cp price_comparison_app.jsx app/page.jsx

# Installer lucide-react
npm install lucide-react

# Lancer
npm run dev
```

---

## Option 3: Déployer sur Vercel (Gratuit & Simple)

### Étape 1: Créer un compte
- Aller sur [vercel.com](https://vercel.com)
- S'enregistrer avec GitHub/GitLab

### Étape 2: Créer un repo GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/USERNAME/price-comparison-app.git
git push -u origin main
```

### Étape 3: Importer sur Vercel
1. Aller sur [vercel.com/new](https://vercel.com/new)
2. Sélectionner votre repo GitHub
3. Cliquer "Deploy"
4. ✅ App live à `https://votre-app.vercel.app`

---

## Option 4: Hébergement Netlify

### Déploiement simple
```bash
# Installer Netlify CLI
npm install -g netlify-cli

# Builder et déployer
npm run build
netlify deploy --prod --dir=build
```

### Ou via interface web
1. Connecter GitHub repo à [netlify.com](https://netlify.com)
2. Configurer build command: `npm run build`
3. Configurer publish: `build`
4. Deploy!

---

## Option 5: Docker (Pour serveurs)

### Dockerfile
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

### Déployer avec Docker
```bash
docker build -t price-comparison .
docker run -p 3000:3000 price-comparison
```

---

## Option 6: Hébergement sur Github Pages (Static)

```bash
# Dans package.json, ajouter:
"homepage": "https://username.github.io/price-comparison-app"

# Installer gh-pages
npm install --save-dev gh-pages

# Builder et déployer
npm run build
npx gh-pages -d build

# Aller sur Settings > Pages > Deploy from branch (gh-pages)
```

---

## Option 7: Ajouter un Backend (Base de Données)

### Architecture avec API

```
Frontend (React)
     ↓
Backend (Express/Node)
     ↓
Database (MongoDB/PostgreSQL)
```

### Exemple Express.js

```javascript
// server.js
const express = require('express');
const cors = require('cors');
const MongoClient = require('mongodb').MongoClient;

const app = express();
app.use(cors());
app.use(express.json());

const MONGO_URL = process.env.MONGO_URL || 'mongodb://localhost:27017';
let db;

MongoClient.connect(MONGO_URL, (err, client) => {
  if (err) throw err;
  db = client.db('price-comparison');
});

// API: Ajouter un produit
app.post('/api/products', async (req, res) => {
  const product = req.body;
  const result = await db.collection('pending').insertOne(product);
  res.json(result);
});

// API: Obtenir les produits en attente
app.get('/api/pending', async (req, res) => {
  const pending = await db.collection('pending').find().toArray();
  res.json(pending);
});

// API: Valider un produit
app.post('/api/validate/:id', async (req, res) => {
  const { id } = req.params;
  const { userId, approved } = req.body;
  
  const product = await db.collection('pending').findOne({ id: parseInt(id) });
  
  if (approved) {
    product.validations = [...(product.validations || []), userId];
  } else {
    product.rejections = (product.rejections || 0) + 1;
  }
  
  if (product.validations.length >= 2) {
    // Déplacer vers les produits confirmés
    await db.collection('confirmed').insertOne({
      ...product,
      confirmedAt: new Date(),
      confidenceScore: Math.min(100, product.validations.length * 25)
    });
    await db.collection('pending').deleteOne({ id: parseInt(id) });
  }
  
  res.json({ success: true });
});

app.listen(5000, () => console.log('Server running on port 5000'));
```

### Variables d'environnement (.env)
```
MONGO_URL=mongodb+srv://user:password@cluster.mongodb.net/price-comparison
PORT=5000
NODE_ENV=production
```

---

## Option 8: Synchroniser avec une API

### Modifier le React pour utiliser une API

```javascript
// Remplacer la sauvegarde localStorage par des appels API

const handleAddProduct = async (e) => {
  e.preventDefault();
  
  const newEntry = {
    name: formData.name,
    price: parseFloat(formData.price),
    store: formData.store,
    category: formData.category,
    submittedBy: userId,
    validations: [],
    rejections: 0,
  };
  
  try {
    const response = await fetch('https://your-api.com/api/products', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newEntry)
    });
    
    if (response.ok) {
      alert('Produit ajouté!');
      setFormData({ name: '', price: '', store: '', category: '' });
      // Recharger les données
      fetchProducts();
    }
  } catch (error) {
    console.error('Erreur:', error);
  }
};

const fetchProducts = async () => {
  try {
    const response = await fetch('https://your-api.com/api/products');
    const data = await response.json();
    setProducts(data);
  } catch (error) {
    console.error('Erreur:', error);
  }
};
```

---

## Performance & Optimisations

### Optimiser pour >10,000 produits

```javascript
// Ajouter pagination
const [page, setPage] = useState(1);
const ITEMS_PER_PAGE = 50;

const paginatedProducts = products.slice(
  (page - 1) * ITEMS_PER_PAGE,
  page * ITEMS_PER_PAGE
);

// Ajouter cache
const cache = new Map();

const getCachedProducts = (category) => {
  if (cache.has(category)) return cache.get(category);
  
  const filtered = products.filter(p => p.category === category);
  cache.set(category, filtered);
  return filtered;
};

// Indexer par catégorie
const productIndex = {};
products.forEach(p => {
  if (!productIndex[p.category]) productIndex[p.category] = [];
  productIndex[p.category].push(p);
});
```

---

## Sécurité

### Protections essentielles

```javascript
// 1. Valider les inputs
const validateInput = (input) => {
  if (!input || input.trim() === '') return false;
  if (input.length > 500) return false; // Max 500 caractères
  return true;
};

// 2. Nettoyer les données
const sanitize = (input) => {
  return input
    .trim()
    .replace(/[<>]/g, '') // Éviter les tags
    .substring(0, 500);
};

// 3. Rate limiting (côté backend)
const rateLimit = {};

app.use((req, res, next) => {
  const ip = req.ip;
  if (!rateLimit[ip]) rateLimit[ip] = 0;
  
  if (rateLimit[ip] > 100) {
    return res.status(429).json({ error: 'Trop de requêtes' });
  }
  
  rateLimit[ip]++;
  setTimeout(() => rateLimit[ip]--, 60000); // Reset par minute
  next();
});

// 4. Authentification (optionnel)
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) return res.sendStatus(401);
  
  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};
```

---

## Monitoring & Analytics

### Ajouter Sentry pour les erreurs

```bash
npm install @sentry/react @sentry/tracing
```

```javascript
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "https://your-dsn@sentry.io/project-id",
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
});

export default Sentry.withProfiler(App);
```

### Ajouter Google Analytics

```html
<!-- Dans index.html -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

---

## Checklist Déploiement

- [ ] Tester localement (`npm start`)
- [ ] Variables d'environnement configurées
- [ ] CORS configuré correctement
- [ ] Validations d'input en place
- [ ] Test de performance (`npm run build`)
- [ ] Test sur mobile
- [ ] Domaine personnalisé (optionnel)
- [ ] HTTPS activé
- [ ] Backups base de données
- [ ] Monitoring configuré
- [ ] Documentation à jour

---

## Support & Ressources

| Ressource | Lien |
|-----------|------|
| React Docs | [react.dev](https://react.dev) |
| Vercel Docs | [vercel.com/docs](https://vercel.com/docs) |
| MongoDB Atlas | [mongodb.com/atlas](https://mongodb.com/atlas) |
| Express Docs | [expressjs.com](https://expressjs.com) |
| Docker | [docker.com](https://docker.com) |

---

**Besoin d'aide?** Consultez la documentation complète: `DOCUMENTATION.md`