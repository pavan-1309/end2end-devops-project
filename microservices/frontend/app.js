const API_BASE = window.location.origin;
const USER_API = `${API_BASE}/api/users`;
const PRODUCT_API = `${API_BASE}/api/products`;

// Service Health Check
async function checkServiceHealth() {
    try {
        const userHealth = await fetch(`${USER_API}/health`);
        document.getElementById('user-service-status').querySelector('.status').textContent = 
            userHealth.ok ? '✅ Healthy' : '❌ Down';
        document.getElementById('user-service-status').querySelector('.status').className = 
            userHealth.ok ? 'status healthy' : 'status down';
    } catch (error) {
        document.getElementById('user-service-status').querySelector('.status').textContent = '❌ Down';
        document.getElementById('user-service-status').querySelector('.status').className = 'status down';
    }

    try {
        const productHealth = await fetch(`${PRODUCT_API}/health`);
        document.getElementById('product-service-status').querySelector('.status').textContent = 
            productHealth.ok ? '✅ Healthy' : '❌ Down';
        document.getElementById('product-service-status').querySelector('.status').className = 
            productHealth.ok ? 'status healthy' : 'status down';
    } catch (error) {
        document.getElementById('product-service-status').querySelector('.status').textContent = '❌ Down';
        document.getElementById('product-service-status').querySelector('.status').className = 'status down';
    }
}

// Tab Management
function showTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    
    document.getElementById(`${tabName}-tab`).classList.add('active');
    event.target.classList.add('active');
    
    if (tabName === 'users') loadUsers();
    if (tabName === 'products') loadProducts();
}

// User Management
document.getElementById('user-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const name = document.getElementById('user-name').value;
    const email = document.getElementById('user-email').value;
    
    try {
        await fetch(USER_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, email })
        });
        document.getElementById('user-form').reset();
        loadUsers();
    } catch (error) {
        alert('Failed to add user');
    }
});

async function loadUsers() {
    try {
        const response = await fetch(USER_API);
        const users = await response.json();
        
        const usersList = document.getElementById('users-list');
        usersList.innerHTML = users.length ? users.map(user => `
            <div class="item-card">
                <h3>${user.name}</h3>
                <p>📧 ${user.email}</p>
                <small>Created: ${new Date(user.createdAt).toLocaleString()}</small>
                <button onclick="deleteUser(${user.id})" class="delete-btn">Delete</button>
            </div>
        `).join('') : '<p class="empty">No users found</p>';
    } catch (error) {
        document.getElementById('users-list').innerHTML = '<p class="error">Failed to load users</p>';
    }
}

async function deleteUser(id) {
    if (confirm('Delete this user?')) {
        try {
            await fetch(`${USER_API}/${id}`, { method: 'DELETE' });
            loadUsers();
        } catch (error) {
            alert('Failed to delete user');
        }
    }
}

// Product Management
document.getElementById('product-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const name = document.getElementById('product-name').value;
    const description = document.getElementById('product-description').value;
    const price = document.getElementById('product-price').value;
    
    try {
        await fetch(PRODUCT_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, description, price })
        });
        document.getElementById('product-form').reset();
        loadProducts();
    } catch (error) {
        alert('Failed to add product');
    }
});

async function loadProducts() {
    try {
        const response = await fetch(PRODUCT_API);
        const products = await response.json();
        
        const productsList = document.getElementById('products-list');
        productsList.innerHTML = products.length ? products.map(product => `
            <div class="item-card">
                <h3>${product.name}</h3>
                <p>${product.description}</p>
                <p class="price">💰 $${product.price}</p>
                <small>Created: ${new Date(product.createdAt).toLocaleString()}</small>
                <button onclick="deleteProduct(${product.id})" class="delete-btn">Delete</button>
            </div>
        `).join('') : '<p class="empty">No products found</p>';
    } catch (error) {
        document.getElementById('products-list').innerHTML = '<p class="error">Failed to load products</p>';
    }
}

async function deleteProduct(id) {
    if (confirm('Delete this product?')) {
        try {
            await fetch(`${PRODUCT_API}/${id}`, { method: 'DELETE' });
            loadProducts();
        } catch (error) {
            alert('Failed to delete product');
        }
    }
}

// Initialize
checkServiceHealth();
loadUsers();
setInterval(checkServiceHealth, 30000); // Check health every 30 seconds