import React, { useState, useEffect, useId } from 'react';
import { Trash2, CheckCircle, XCircle, TrendingDown } from 'lucide-react';

export default function PriceComparison() {
  const userId = useId().slice(0, 8);
  const [products, setProducts] = useState([]);
  const [pendingValidation, setPendingValidation] = useState([]);
  const [formData, setFormData] = useState({ name: '', price: '', store: '', category: '' });
  const [tab, setTab] = useState('add');
  const [userValidations, setUserValidations] = useState(new Set());

  // Charger les données du localStorage au démarrage
  useEffect(() => {
    const savedProducts = JSON.parse(localStorage.getItem('products') || '[]');
    const savedPending = JSON.parse(localStorage.getItem('pendingValidation') || '[]');
    const savedValidations = JSON.parse(localStorage.getItem('userValidations') || '[]');
    setProducts(savedProducts);
    setPendingValidation(savedPending);
    setUserValidations(new Set(savedValidations));
  }, []);

  // Sauvegarder les produits validés
  useEffect(() => {
    localStorage.setItem('products', JSON.stringify(products));
  }, [products]);

  // Sauvegarder les données en attente
  useEffect(() => {
    localStorage.setItem('pendingValidation', JSON.stringify(pendingValidation));
  }, [pendingValidation]);

  // Sauvegarder les validations utilisateur
  useEffect(() => {
    localStorage.setItem('userValidations', JSON.stringify(Array.from(userValidations)));
  }, [userValidations]);

  // Ajouter un nouveau produit/prix en attente de validation
  const handleAddProduct = (e) => {
    e.preventDefault();
    if (!formData.name || !formData.price || !formData.store) {
      alert('Remplissez tous les champs');
      return;
    }

    const newEntry = {
      id: Date.now(),
      name: formData.name,
      price: parseFloat(formData.price),
      store: formData.store,
      category: formData.category || 'Autre',
      submittedBy: userId,
      timestamp: new Date().toLocaleDateString('fr-FR'),
      validations: [],
      rejections: 0,
    };

    setPendingValidation([...pendingValidation, newEntry]);
    setFormData({ name: '', price: '', store: '', category: '' });
    alert('Produit ajouté ! En attente de validation par au moins 2 utilisateurs.');
  };

  // Valider une entrée
  const handleValidate = (id, isValid) => {
    const updatedPending = pendingValidation.map((item) => {
      if (item.id === id) {
        if (isValid) {
          return {
            ...item,
            validations: [...new Set([...item.validations, userId])],
          };
        } else {
          return { ...item, rejections: item.rejections + 1 };
        }
      }
      return item;
    });

    const itemToCheck = updatedPending.find((item) => item.id === id);

    // Si validé par 2+ utilisateurs, passer aux produits finaux
    if (itemToCheck?.validations.length >= 2) {
      const confirmedItem = {
        ...itemToCheck,
        confirmedAt: new Date().toLocaleDateString('fr-FR'),
        confidenceScore: calculateConfidence(itemToCheck.validations.length),
      };
      setProducts([...products, confirmedItem]);
      setPendingValidation(updatedPending.filter((item) => item.id !== id));
    }
    // Si rejeté par 2+ utilisateurs, supprimer
    else if (itemToCheck?.rejections >= 2) {
      setPendingValidation(updatedPending.filter((item) => item.id !== id));
    } else {
      setPendingValidation(updatedPending);
    }

    userValidations.add(id);
    setUserValidations(new Set(userValidations));
  };

  // Calculer le score de confiance
  const calculateConfidence = (validationCount) => {
    return Math.min(100, validationCount * 25);
  };

  // Grouper les produits par catégorie pour comparaison
  const groupedByCategory = products.reduce((acc, item) => {
    if (!acc[item.category]) acc[item.category] = {};
    if (!acc[item.category][item.name]) acc[item.category][item.name] = [];
    acc[item.category][item.name].push(item);
    return acc;
  }, {});

  // Trouver le meilleur prix
  const getBestPrice = (stores) => {
    return Math.min(...stores.map((s) => s.price));
  };

  return (
    <div style={{ padding: '1.5rem', background: 'var(--color-background-tertiary)', minHeight: '100vh' }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        {/* En-tête */}
        <div style={{ marginBottom: '2rem' }}>
          <h1 style={{ fontSize: '28px', fontWeight: '500', margin: '0 0 0.5rem 0', color: 'var(--color-text-primary)' }}>
            Comparateur de prix communautaire
          </h1>
          <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', margin: 0 }}>
            Partagez les prix, validez les données, trouvez les meilleures offres
          </p>
        </div>

        {/* Navigation par onglets */}
        <div style={{ display: 'flex', gap: '8px', marginBottom: '1.5rem', borderBottom: '0.5px solid var(--color-border-tertiary)', paddingBottom: '1rem' }}>
          {[
            { id: 'add', label: 'Ajouter un prix' },
            { id: 'validate', label: `Valider (${pendingValidation.length})`, badge: pendingValidation.length },
            { id: 'compare', label: 'Comparaison des prix' },
          ].map((t) => (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              style={{
                padding: '0.5rem 1rem',
                background: tab === t.id ? 'var(--color-background-secondary)' : 'transparent',
                border: tab === t.id ? '0.5px solid var(--color-border-secondary)' : '0.5px solid transparent',
                borderRadius: 'var(--border-radius-md)',
                cursor: 'pointer',
                fontSize: '14px',
                fontWeight: 500,
                color: 'var(--color-text-primary)',
                position: 'relative',
              }}
            >
              {t.label}
              {t.badge ? (
                <span
                  style={{
                    display: 'inline-block',
                    background: 'var(--color-background-danger)',
                    color: 'white',
                    borderRadius: '50%',
                    width: '20px',
                    height: '20px',
                    fontSize: '12px',
                    fontWeight: 'bold',
                    lineHeight: '20px',
                    textAlign: 'center',
                    marginLeft: '0.5rem',
                  }}
                >
                  {t.badge}
                </span>
              ) : null}
            </button>
          ))}
        </div>

        {/* Onglet Ajouter */}
        {tab === 'add' && (
          <div style={{ background: 'var(--color-background-primary)', borderRadius: 'var(--border-radius-lg)', border: '0.5px solid var(--color-border-tertiary)', padding: '1.5rem' }}>
            <h2 style={{ fontSize: '18px', fontWeight: '500', margin: '0 0 1.5rem 0' }}>Ajouter un nouveau prix</h2>
            <form onSubmit={handleAddProduct}>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1rem', marginBottom: '1.5rem' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, marginBottom: '0.5rem', color: 'var(--color-text-secondary)' }}>
                    Nom du produit
                  </label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="Ex: Lait 1L"
                    style={{ width: '100%', padding: '0.75rem', border: '0.5px solid var(--color-border-tertiary)', borderRadius: 'var(--border-radius-md)' }}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, marginBottom: '0.5rem', color: 'var(--color-text-secondary)' }}>
                    Prix (€)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={formData.price}
                    onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                    placeholder="0.00"
                    style={{ width: '100%', padding: '0.75rem', border: '0.5px solid var(--color-border-tertiary)', borderRadius: 'var(--border-radius-md)' }}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, marginBottom: '0.5rem', color: 'var(--color-text-secondary)' }}>
                    Magasin
                  </label>
                  <input
                    type="text"
                    value={formData.store}
                    onChange={(e) => setFormData({ ...formData, store: e.target.value })}
                    placeholder="Ex: Carrefour"
                    style={{ width: '100%', padding: '0.75rem', border: '0.5px solid var(--color-border-tertiary)', borderRadius: 'var(--border-radius-md)' }}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, marginBottom: '0.5rem', color: 'var(--color-text-secondary)' }}>
                    Catégorie
                  </label>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    style={{ width: '100%', padding: '0.75rem', border: '0.5px solid var(--color-border-tertiary)', borderRadius: 'var(--border-radius-md)' }}
                  >
                    <option value="">-- Sélectionner --</option>
                    <option value="Alimentation">Alimentation</option>
                    <option value="Électronique">Électronique</option>
                    <option value="Vêtements">Vêtements</option>
                    <option value="Maison">Maison</option>
                    <option value="Hygiène">Hygiène</option>
                    <option value="Autre">Autre</option>
                  </select>
                </div>
              </div>
              <button
                type="submit"
                style={{
                  padding: '0.75rem 1.5rem',
                  background: 'var(--color-background-info)',
                  color: 'white',
                  border: 'none',
                  borderRadius: 'var(--border-radius-md)',
                  cursor: 'pointer',
                  fontWeight: 500,
                  fontSize: '14px',
                }}
              >
                Soumettre pour validation
              </button>
            </form>
          </div>
        )}

        {/* Onglet Valider */}
        {tab === 'validate' && (
          <div>
            {pendingValidation.length === 0 ? (
              <div style={{ background: 'var(--color-background-secondary)', borderRadius: 'var(--border-radius-lg)', padding: '2rem', textAlign: 'center' }}>
                <p style={{ color: 'var(--color-text-secondary)' }}>Aucun produit en attente de validation</p>
              </div>
            ) : (
              <div style={{ display: 'grid', gap: '1rem' }}>
                {pendingValidation.map((item) => (
                  <div
                    key={item.id}
                    style={{
                      background: 'var(--color-background-primary)',
                      border: '0.5px solid var(--color-border-tertiary)',
                      borderRadius: 'var(--border-radius-lg)',
                      padding: '1rem',
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', marginBottom: '1rem' }}>
                      <div>
                        <h3 style={{ margin: '0 0 0.5rem 0', fontSize: '16px', fontWeight: 500 }}>{item.name}</h3>
                        <p style={{ margin: 0, fontSize: '13px', color: 'var(--color-text-secondary)' }}>
                          {item.store} • {item.category} • {item.timestamp}
                        </p>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <p style={{ margin: 0, fontSize: '20px', fontWeight: 500, color: 'var(--color-text-info)' }}>{item.price.toFixed(2)}€</p>
                      </div>
                    </div>

                    <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1rem', fontSize: '13px' }}>
                      <span style={{ background: 'var(--color-background-success)', color: 'var(--color-text-success)', padding: '0.25rem 0.75rem', borderRadius: 'var(--border-radius-md)' }}>
                        ✓ {item.validations.length} validation{item.validations.length > 1 ? 's' : ''}
                      </span>
                      {item.rejections > 0 && (
                        <span style={{ background: 'var(--color-background-danger)', color: 'white', padding: '0.25rem 0.75rem', borderRadius: 'var(--border-radius-md)' }}>
                          ✕ {item.rejections} rejet{item.rejections > 1 ? 's' : ''}
                        </span>
                      )}
                    </div>

                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <button
                        onClick={() => handleValidate(item.id, true)}
                        disabled={userValidations.has(item.id)}
                        style={{
                          flex: 1,
                          padding: '0.75rem',
                          background: 'var(--color-background-success)',
                          color: 'white',
                          border: 'none',
                          borderRadius: 'var(--border-radius-md)',
                          cursor: userValidations.has(item.id) ? 'default' : 'pointer',
                          fontWeight: 500,
                          opacity: userValidations.has(item.id) ? 0.5 : 1,
                          fontSize: '14px',
                        }}
                      >
                        ✓ Valider
                      </button>
                      <button
                        onClick={() => handleValidate(item.id, false)}
                        disabled={userValidations.has(item.id)}
                        style={{
                          flex: 1,
                          padding: '0.75rem',
                          background: 'var(--color-background-danger)',
                          color: 'white',
                          border: 'none',
                          borderRadius: 'var(--border-radius-md)',
                          cursor: userValidations.has(item.id) ? 'default' : 'pointer',
                          fontWeight: 500,
                          opacity: userValidations.has(item.id) ? 0.5 : 1,
                          fontSize: '14px',
                        }}
                      >
                        ✕ Rejeter
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Onglet Comparaison */}
        {tab === 'compare' && (
          <div>
            {products.length === 0 ? (
              <div style={{ background: 'var(--color-background-secondary)', borderRadius: 'var(--border-radius-lg)', padding: '2rem', textAlign: 'center' }}>
                <p style={{ color: 'var(--color-text-secondary)' }}>Aucun produit validé pour le moment</p>
              </div>
            ) : (
              Object.entries(groupedByCategory).map(([category, products_by_name]) => (
                <div key={category} style={{ marginBottom: '2rem' }}>
                  <h2 style={{ fontSize: '18px', fontWeight: 500, margin: '1rem 0 1rem 0', color: 'var(--color-text-primary)' }}>
                    {category}
                  </h2>
                  <div style={{ overflowX: 'auto' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                      <thead>
                        <tr style={{ borderBottom: '0.5px solid var(--color-border-tertiary)' }}>
                          <th style={{ textAlign: 'left', padding: '0.75rem', fontSize: '13px', fontWeight: 500, color: 'var(--color-text-secondary)' }}>
                            Produit
                          </th>
                          <th style={{ textAlign: 'left', padding: '0.75rem', fontSize: '13px', fontWeight: 500, color: 'var(--color-text-secondary)' }}>
                            Magasin
                          </th>
                          <th style={{ textAlign: 'right', padding: '0.75rem', fontSize: '13px', fontWeight: 500, color: 'var(--color-text-secondary)' }}>
                            Prix
                          </th>
                          <th style={{ textAlign: 'center', padding: '0.75rem', fontSize: '13px', fontWeight: 500, color: 'var(--color-text-secondary)' }}>
                            Confiance
                          </th>
                          <th style={{ textAlign: 'center', padding: '0.75rem', fontSize: '13px', fontWeight: 500, color: 'var(--color-text-secondary)' }}>
                            Économie
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {Object.entries(products_by_name).map(([productName, stores]) => {
                          const bestPrice = getBestPrice(stores);
                          return stores.map((store, idx) => {
                            const isBest = store.price === bestPrice;
                            const savings = store.price !== bestPrice ? ((store.price - bestPrice) / store.price * 100).toFixed(1) : 0;
                            return (
                              <tr
                                key={store.id}
                                style={{
                                  background: isBest ? 'var(--color-background-success)' : 'transparent',
                                  borderBottom: '0.5px solid var(--color-border-tertiary)',
                                }}
                              >
                                <td style={{ padding: '0.75rem', fontSize: '14px', fontWeight: idx === 0 ? 500 : 400 }}>
                                  {idx === 0 ? productName : ''}
                                </td>
                                <td style={{ padding: '0.75rem', fontSize: '14px' }}>{store.store}</td>
                                <td style={{ padding: '0.75rem', textAlign: 'right', fontSize: '14px', fontWeight: 500, color: isBest ? 'var(--color-text-success)' : 'var(--color-text-primary)' }}>
                                  {store.price.toFixed(2)}€
                                </td>
                                <td style={{ padding: '0.75rem', textAlign: 'center' }}>
                                  <div
                                    style={{
                                      display: 'inline-block',
                                      background: store.confidenceScore > 75 ? 'var(--color-background-success)' : store.confidenceScore > 50 ? 'var(--color-background-info)' : 'var(--color-background-warning)',
                                      color: 'white',
                                      padding: '0.25rem 0.75rem',
                                      borderRadius: 'var(--border-radius-md)',
                                      fontSize: '12px',
                                      fontWeight: 500,
                                    }}
                                  >
                                    {store.confidenceScore}%
                                  </div>
                                </td>
                                <td style={{ padding: '0.75rem', textAlign: 'center', fontSize: '13px', color: isBest ? 'var(--color-text-success)' : 'var(--color-text-danger)' }}>
                                  {isBest ? '✓ Meilleur' : `+${savings}%`}
                                </td>
                              </tr>
                            );
                          });
                        })}
                      </tbody>
                    </table>
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>
    </div>
  );
}