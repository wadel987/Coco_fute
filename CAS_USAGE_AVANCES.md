# 🎯 Cas d'Usage Avancés & Exemples Détaillés

## 📚 Table des Matières
1. Scénarios Réalistes
2. Algorithmes Avancés
3. Extensions Possibles
4. Intégrations Tierces

---

## 📖 Scénario 1: Shopping Intelligent pour Famille

### Situation
Famille de 4 personnes cherchant à économiser sur le budget alimentaire.

### Utilisation
```
Lundi - Sarah ajoute les prix:
├─ Lait 1L: 1,29€ @ Carrefour
├─ Œufs x12: 2,49€ @ Leclerc
├─ Fromage 200g: 3,99€ @ Intermarché
└─ Pain complet: 1,79€ @ Casino

Mardi - Pierre valide depuis Leclerc (validation #1)
Mercredi - Marie valide depuis Intermarché (validation #2)

👉 Tous les produits confirmés!

Jeudi - Famille regarde comparaison:
┌─────────────┬──────────┬──────────┐
│ Produit     │ Mag.     │ Prix     │
├─────────────┼──────────┼──────────┤
│ Lait 1L     │ Carrefour│ 1,29€ ✓  │
│             │ Leclerc  │ 1,45€    │
│ Œufs x12    │ Leclerc  │ 2,49€ ✓  │
│             │ Carrefour│ 2,89€    │
└─────────────┴──────────┴──────────┘

💰 Économie totale: ~0,55€ par semaine
    = ~30€ par an!
```

---

## 📖 Scénario 2: Startup E-Commerce

### Situation
Jeune startup vendant des produits électroniques veut connaitre les prix concurrents.

### Utilisation
```
VIA API (intégration automatique):

Monday -> Ajouter automátiquement tous les produits
         avec prix concurrents

Webhook GitHub:
  Nouveau produit sur site
  → Déclenche requête API
  → Ajoute données de concurrents

GET /api/products/smartphone?category=Électronique
Response:
{
  "product": "Samsung A14",
  "ourPrice": 199,
  "competitors": [
    { "store": "Amazon", "price": 189, "confidence": 100 },
    { "store": "Fnac", "price": 195, "confidence": 75 },
    { "store": "Darty", "price": 205, "confidence": 50 }
  ],
  "recommendation": "Prix compétitif, légèrement au-dessus du marché"
}

STRATÉGIE: Réduire à 189€ pour dominer le marché!
```

---

## 📖 Scénario 3: Community Manager pour Réseau de Magasins

### Situation
Chaîne de 50 magasins veut avoir les prix à jour en temps réel.

### Utilisation
```
WORKFLOW:

1. COLLECTE (Chaque magasin ajoute ses prix)
   ├─ Lundi: Magasin Paris ajoute 100 produits
   ├─ Mardi: Magasin Lyon ajoute 100 produits
   └─ Mercredi: Magasin Marseille ajoute 100 produits

2. VALIDATION (Minimum 2 magasins confirment)
   ├─ Laiterie: Lait 1L confirmé par 3 magasins ✓ (100%)
   ├─ Fruits: Pommes 1kg confirmé par 2 magasins ✓ (50%)
   └─ Viande: Steak 500g confirmé par 1 magasin ⏳ (25%)

3. COMPARAISON INTERNE
   Lait 1L:
   ├─ Paris: 1,15€
   ├─ Lyon: 1,20€
   ├─ Marseille: 1,10€ ← MEILLEUR PRIX
   
   ACTION: Aligner tous les magasins sur 1,10€

4. ALERTES ANOMALIES
   Steak 500g soudain 8,99€ au lieu de 5,99€?
   → Alerte modérateur
   → Vérifier les données
```

---

## 🧮 Algorithme Avancé 1: Scoring de Fiabilité Pondéré

### Problème
Actuellement: Score = validations * 25 (trop simple)

### Solution
```javascript
/**
 * Calcule un score de confiance plus sophistiqué
 * en tenant compte de plusieurs facteurs
 */
function calculateAdvancedConfidence(product) {
  // Facteur 1: Nombre de validations
  const validationScore = Math.min(100, product.validations.length * 30);
  
  // Facteur 2: Diversité des validateurs (différents magasins)
  const uniqueStores = new Set(
    product.validations.map(v => validatorDetails[v]?.store)
  ).size;
  const diversityScore = Math.min(100, uniqueStores * 25);
  
  // Facteur 3: Récence des données
  const daysOld = Math.floor(
    (Date.now() - new Date(product.timestamp)) / (1000 * 60 * 60 * 24)
  );
  const recencyScore = Math.max(0, 100 - daysOld * 5); // -5% par jour
  
  // Facteur 4: Cohérence des prix (pas d'anomalies)
  const similarPrices = products
    .filter(p => p.name === product.name && p.store !== product.store)
    .map(p => p.price);
  
  const avgPrice = similarPrices.reduce((a, b) => a + b, 0) / similarPrices.length;
  const priceDeviation = Math.abs(product.price - avgPrice) / avgPrice;
  const consistencyScore = Math.max(0, 100 - priceDeviation * 200);
  
  // Facteur 5: Historique du contributeur
  const contributorAccuracy = calculateContributorReputation(product.submittedBy);
  
  // Score final (moyennes pondérées)
  const finalScore = 
    validationScore * 0.35 +      // 35% poids
    diversityScore * 0.25 +       // 25% poids
    recencyScore * 0.20 +         // 20% poids
    consistencyScore * 0.15 +     // 15% poids
    contributorAccuracy * 0.05;   // 5% poids
  
  return Math.round(finalScore);
}

// Exemple:
// Lait 1L @ Carrefour:
// - 5 validations (75 pts)
// - 3 magasins différents (75 pts)
// - 2 jours (90 pts)
// - Prix cohérent (95 pts)
// - Contributeur fiable (100 pts)
// SCORE = 75*0.35 + 75*0.25 + 90*0.20 + 95*0.15 + 100*0.05 = 80/100 🟢
```

---

## 🧮 Algorithme Avancé 2: Détection d'Anomalies

### Problème
Détecter les prix incorrects automatiquement

### Solution
```javascript
/**
 * Détecte si un prix semble anormal
 * (manipulation, erreur de saisie, etc.)
 */
function detectAnomalies(newProduct) {
  const similar = products.filter(p => p.name === newProduct.name);
  
  if (similar.length < 3) {
    return { isAnomaly: false, reason: 'Pas assez de données' };
  }
  
  // Moyenne et écart-type
  const prices = similar.map(p => p.price);
  const mean = prices.reduce((a, b) => a + b) / prices.length;
  const variance = prices.reduce((sum, p) => sum + Math.pow(p - mean, 2), 0) / prices.length;
  const stdDev = Math.sqrt(variance);
  
  // Test Z-score (écart par rapport à la moyenne)
  const zScore = Math.abs((newProduct.price - mean) / stdDev);
  
  // Seuil: si |Z| > 3, c'est une anomalie (>99.7% de confiance)
  if (zScore > 3) {
    return {
      isAnomaly: true,
      reason: `Prix anormal: ${newProduct.price}€ vs moyenne ${mean.toFixed(2)}€`,
      zScore: zScore.toFixed(2),
      suggestedAction: 'Demander vérification manuelle'
    };
  }
  
  return { isAnomaly: false, reason: 'Prix normal' };
}

// EXEMPLE:
const newMilk = { name: 'Lait 1L', price: 50, store: 'Carrefour' };
// Données existantes: 1,29€, 1,45€, 1,39€ (moyenne: 1,38€)
// Z-score = |50 - 1.38| / 0.07 = 694 !!!
// 👉 ALERTE ANOMALIE - Erreur de saisie probable (50€ au lieu de 1.50€?)
```

---

## 🧮 Algorithme Avancé 3: Prédiction de Prix

### Problème
Prévoir les prix futurs basés sur l'historique

### Solution
```javascript
/**
 * Prédit le prix futur avec tendance linéaire
 */
function predictFuturePrice(productName, daysAhead = 7) {
  const history = products
    .filter(p => p.name === productName)
    .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  
  if (history.length < 3) {
    return { error: 'Pas assez d\'historique' };
  }
  
  // Créer points (jour, prix)
  const points = history.map((p, i) => ({
    day: i,
    price: p.price
  }));
  
  // Régression linéaire
  const n = points.length;
  const sumX = points.reduce((s, p) => s + p.day, 0);
  const sumY = points.reduce((s, p) => s + p.price, 0);
  const sumXY = points.reduce((s, p) => s + p.day * p.price, 0);
  const sumX2 = points.reduce((s, p) => s + p.day * p.day, 0);
  
  const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  const intercept = (sumY - slope * sumX) / n;
  
  const predictedPrice = intercept + slope * (n - 1 + daysAhead);
  
  return {
    currentPrice: history[history.length - 1].price,
    predictedPrice: predictedPrice.toFixed(2),
    trend: slope > 0 ? '📈 En hausse' : '📉 En baisse',
    daysAhead: daysAhead
  };
}

// EXEMPLE:
// Lait 1L historique:
// Jour 1: 1,29€
// Jour 2: 1,31€
// Jour 3: 1,33€ ← Tendance +0,02€/jour
// Prédiction J+7: 1,33 + (0,02 * 7) = 1,47€ 📈
```

---

## 📱 Extension 1: Application Mobile Native

### Intégration React Native
```javascript
// App.js (React Native)
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import PriceComparison from './PriceComparison';

export default function App() {
  return (
    <View style={styles.container}>
      <PriceComparison />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
});

// Partager le code:
// ├─ Composants métier (validation, algo) → Code partagé
// ├─ UI React → Web uniquement
// └─ UI React Native → Mobile uniquement
```

---

## 📱 Extension 2: Feature - Scan Codes Barres

### Intégration Vision API
```javascript
import { BarcodeScanner } from '@react-native-camera-kit/vision';

async function scanProduct() {
  try {
    const barcode = await BarcodeScanner.scan();
    
    // Appel API produit
    const response = await fetch(
      `https://api.ean-search.org/?q=${barcode}`
    );
    const data = await response.json();
    
    // Remplissage automatique du formulaire
    setFormData({
      name: data.product,
      category: data.category,
      price: '', // L'utilisateur entre le prix
      store: ''
    });
  } catch (error) {
    console.error('Erreur scan:', error);
  }
}
```

---

## 🗺️ Extension 3: Géolocalisation

### Afficher magasins proches
```javascript
import * as Location from 'expo-location';

async function getNearbyStores() {
  // Permission géolocalisation
  let { status } = await Location.requestForegroundPermissionsAsync();
  if (status !== 'granted') return;
  
  // Localisation
  let location = await Location.getCurrentPositionAsync({});
  const { latitude, longitude } = location.coords;
  
  // Trouver magasins proches
  const nearbyStores = products
    .filter(p => {
      const distance = calculateDistance(
        latitude, longitude,
        p.store.location.lat, p.store.location.lng
      );
      return distance < 5; // Dans 5km
    })
    .groupBy('store')
    .map(group => ({
      name: group[0].store,
      distance: calculateDistance(...),
      productCount: group.length,
      avgPrice: group.reduce((s, p) => s + p.price, 0) / group.length
    }));
  
  return nearbyStores.sort((a, b) => a.distance - b.distance);
}

// Affichage:
// 🏪 Carrefour (500m)
//    - 45 produits, prix moyen: 2,50€
// 🏪 Leclerc (800m)
//    - 38 produits, prix moyen: 2,40€ ← Moins cher!
```

---

## 💳 Extension 4: Programme Loyalty/Récompenses

### Gamification & Récompenses
```javascript
/**
 * Système de points pour contributeurs
 */
class LoyaltySystem {
  calculatePoints(user) {
    let points = 0;
    
    // Points pour ajout (5 pts)
    points += user.productsSubmitted * 5;
    
    // Points bonus si confirmé (10 pts)
    const confirmedProducts = products.filter(
      p => p.submittedBy === user.id && p.validations.length >= 2
    );
    points += confirmedProducts.length * 10;
    
    // Points pour validations (3 pts)
    points += user.validations.length * 3;
    
    // Bonus fidélité (1 pt par semaine d'activité)
    const weeksSinceJoin = Math.floor(
      (Date.now() - user.joinDate) / (7 * 24 * 60 * 60 * 1000)
    );
    points += weeksSinceJoin * 1;
    
    // Bonus précision (5 pts si score >90%)
    if (user.validationAccuracy > 0.9) {
      points += 50;
    }
    
    return points;
  }
  
  getRewards(points) {
    if (points >= 500) return 'Badge Expert ⭐⭐⭐';
    if (points >= 300) return 'Badge Fiable ⭐⭐';
    if (points >= 100) return 'Badge Contributeur ⭐';
    return null;
  }
}

// EXEMPLE:
// Marie - 50 produits ajoutés + 30 validations + 3 mois
// Points: 50*5 + 20*10 + 30*3 + 12*1 = 520
// Reward: Badge Expert ⭐⭐⭐
```

---

## 🔔 Extension 5: Notifications & Alertes

### Alertes prix bas
```javascript
// Utilisateur crée alerte
subscribeToAlert({
  productName: 'Lait 1L',
  maxPrice: 1.20,
  magasins: ['Carrefour', 'Leclerc']
});

// Système monitoring (backend)
setInterval(async () => {
  const products = await db.collection('products').find().toArray();
  
  for (let alert of userAlerts) {
    const match = products.find(p => 
      p.name === alert.productName &&
      alert.magasins.includes(p.store) &&
      p.price <= alert.maxPrice
    );
    
    if (match) {
      // Envoyer notification
      sendNotification(alert.userId, {
        title: `${match.name} en baisse!`,
        body: `${match.store}: ${match.price}€ (≤ ${alert.maxPrice}€)`,
        action: 'Voir détails'
      });
    }
  }
}, 3600000); // Chaque heure
```

---

## 📊 Extension 6: Dashboard Analytics

### Statistiques & Tendances
```javascript
function generateAnalytics() {
  return {
    // Global
    totalProducts: products.length,
    totalCategories: new Set(products.map(p => p.category)).size,
    totalValidations: products.reduce((s, p) => s + p.validations.length, 0),
    
    // Par catégorie
    categoryStats: Object.entries(
      products.reduce((acc, p) => {
        if (!acc[p.category]) {
          acc[p.category] = {
            count: 0,
            avgPrice: 0,
            priceRange: { min: Infinity, max: 0 }
          };
        }
        acc[p.category].count++;
        acc[p.category].avgPrice += p.price;
        acc[p.category].priceRange.min = Math.min(
          acc[p.category].priceRange.min, p.price
        );
        acc[p.category].priceRange.max = Math.max(
          acc[p.category].priceRange.max, p.price
        );
        return acc;
      }, {})
    ).map(([cat, stats]) => ({
      category: cat,
      count: stats.count,
      avgPrice: (stats.avgPrice / stats.count).toFixed(2),
      priceRange: `${stats.priceRange.min.toFixed(2)}€ - ${stats.priceRange.max.toFixed(2)}€`
    })),
    
    // Top magasins
    topStores: Object.entries(
      products.reduce((acc, p) => {
        if (!acc[p.store]) acc[p.store] = 0;
        acc[p.store]++;
        return acc;
      }, {})
    ).sort((a, b) => b[1] - a[1]).slice(0, 10),
    
    // Économies potentielles
    totalSavings: products.reduce((sum, p) => {
      const best = Math.min(...products
        .filter(prod => prod.name === p.name)
        .map(prod => prod.price)
      );
      return sum + (p.price - best);
    }, 0)
  };
}

// Dashboard:
// 📊 Total: 2,450 produits, 95 catégories
// ✓ Validations: 4,890
// 💰 Économies potentielles: 1,245€
// 
// Top catégories:
// 1. Alimentation: 890 produits, avg 2,50€
// 2. Électronique: 234 produits, avg 89,99€
// 3. Vêtements: 145 produits, avg 35,00€
```

---

## 🤖 Extension 7: IA & Machine Learning

### Recommandations personnalisées
```javascript
/**
 * ML: Suggère les meilleures offres basées sur historique
 */
function recommendProducts(userId) {
  // Historique d'achats de l'utilisateur
  const userHistory = getUserPurchaseHistory(userId);
  
  // Produits similaires (même catégorie)
  const recommendations = [];
  for (let purchase of userHistory) {
    const similar = products
      .filter(p => 
        p.category === purchase.category &&
        p.price < purchase.lastPrice * 0.95 && // -5%
        p.confidenceScore > 75
      )
      .sort((a, b) => a.price - b.price)
      .slice(0, 3);
    
    recommendations.push(...similar);
  }
  
  return recommendations.sort((a, b) => {
    const aSavings = (a.price / userHistory
      .find(p => p.name === a.name)?.lastPrice || a.price) - 1;
    const bSavings = (b.price / userHistory
      .find(p => p.name === b.name)?.lastPrice || b.price) - 1;
    return aSavings - bSavings; // Plus d'économies en premier
  });
}

// Résultat:
// RECOMMANDÉ POUR VOUS:
// 💰 Lait 1L @ Carrefour: 1,29€ (économise 0,16€ vs dernier achat)
// 💰 Œufs x12 @ Leclerc: 2,49€ (économise 0,40€)
// 💰 Fromage @ Intermarché: 3,50€ (économise 0,49€)
```

---

## 🔗 Intégration 1: API Tiers - Météo

### Vendre selon la météo
```javascript
async function getPriceByWeather(product) {
  // Obtenir météo actuelle
  const weather = await fetch(
    'https://api.openweathermap.org/data/2.5/weather?...'
  ).then(r => r.json());
  
  // Ajuster prix basé sur la météo
  let relevantPrices = products.filter(p => p.name === product);
  
  if (weather.main.temp < 10 && product.includes('Soupe')) {
    // Froid → plus d'achats de soupe
    // Afficher d'abord les prix bas
    relevantPrices = relevantPrices.sort((a, b) => a.price - b.price);
  }
  
  if (weather.rain > 5 && product.includes('Parapluie')) {
    // Pluie → urgence parapluie
    // Avertir si prix haut
    relevantPrices.forEach(p => {
      if (p.price > avgPrice * 1.2) {
        notify('Prix élevé dû à forte demande');
      }
    });
  }
  
  return relevantPrices;
}
```

---

## 🔗 Intégration 2: API Tiers - E-Commerce

### Synchroniser avec Shopify/WooCommerce
```javascript
async function syncWithShopify() {
  const shopifyAPI = require('shopify-api-node');
  const shopify = new shopifyAPI({
    shop: process.env.SHOP_NAME,
    accessToken: process.env.SHOPIFY_TOKEN
  });
  
  // Récupérer tous les produits Shopify
  const shopifyProducts = await shopify.product.list();
  
  for (let product of shopifyProducts) {
    // Chercher équivalent dans notre app
    const match = products.find(p => 
      p.name.toLowerCase() === product.title.toLowerCase()
    );
    
    if (match) {
      // Comparer prix
      const ourPrice = match.price;
      const shopifyPrice = product.variants[0].price;
      const difference = ((ourPrice - shopifyPrice) / shopifyPrice * 100).toFixed(1);
      
      // Notifier si prix considérablement différent
      if (Math.abs(difference) > 10) {
        console.log(`Alerte prix: ${product.title}`);
        console.log(`  Notre prix: ${ourPrice}€`);
        console.log(`  Shopify: ${shopifyPrice}€`);
        console.log(`  Différence: ${difference}%`);
      }
    }
  }
}
```

---

## Conclusion

Avec ces extensions, l'application devient:
- ✅ **Scalable** (>1M produits)
- ✅ **Intelligent** (ML & prédictions)
- ✅ **Communautaire** (notifications, récompenses)
- ✅ **Intégré** (APIs externes)
- ✅ **Monétisable** (publicités ciblées)

Prochaine étape? Implémenter les extensions une par une! 🚀