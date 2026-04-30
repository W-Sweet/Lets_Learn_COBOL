const select = document.getElementById('example-select');
const container = document.getElementById('text-container');
let KEYWORDS = {};

// ── Tooltip Setup ──────────────────────────────────────────────
const tooltip = document.createElement('div');
tooltip.id = 'cobol-tooltip';
Object.assign(tooltip.style, {
    position: 'fixed', background: '#1e1e2e', color: '#cdd6f4',
    padding: '7px 11px', borderRadius: '6px', fontSize: '12.5px',
    maxWidth: '300px', boxShadow: '0 4px 16px rgba(0,0,0,0.45)',
    zIndex: '9999', pointerEvents: 'none', display: 'none',
    lineHeight: '1.5', border: '1px solid #45475a', whiteSpace: 'pre-wrap'
});
document.body.appendChild(tooltip);

let hideTimer = null;

// ── Core Functionality ─────────────────────────────────────────
async function fetchKeywords() {
    const res = await fetch('/get-keywords');
    KEYWORDS = await res.json();
    renderGlossaryEditor();
}

function positionTooltip(x, y) {
    tooltip.style.display = 'block';
    const tw = tooltip.offsetWidth, th = tooltip.offsetHeight;
    let tx = x + 14, ty = y - th - 10;
    if (tx + tw > window.innerWidth - 12) tx = x - tw - 14;
    if (ty < 12) ty = y + 22;
    tooltip.style.left = tx + 'px';
    tooltip.style.top = ty + 'px';
}

function buildHoverableContent(text) {
    const fragment = document.createDocumentFragment();
    text.split('\n').forEach((line, i) => {
        if (i > 0) fragment.appendChild(document.createTextNode('\n'));
        const parts = line.split(/(\s+|[(),;.]+)/);
        parts.forEach(part => {
            if (!part || /^\s+$/.test(part) || /^[(),;.]+$/.test(part)) {
                fragment.appendChild(document.createTextNode(part));
                return;
            }
            const tip = KEYWORDS[part.toUpperCase()];
            if (tip) {
                const span = document.createElement('span');
                span.textContent = part;
                span.className = 'tok tok-known';
                span.dataset.tip = tip;
                fragment.appendChild(span);
            } else {
                fragment.appendChild(document.createTextNode(part));
            }
        });
    });
    return fragment;
}

function attachHoverListeners(preEl) {
    preEl.addEventListener('mouseover', (e) => {
        const span = e.target.closest('.tok-known');
        if (!span) return;
        clearTimeout(hideTimer);
        tooltip.textContent = span.dataset.tip;
        positionTooltip(e.clientX, e.clientY);
    });
    preEl.addEventListener('mousemove', (e) => {
        if (tooltip.style.display !== 'none') positionTooltip(e.clientX, e.clientY);
    });
    preEl.addEventListener('mouseout', () => {
        hideTimer = setTimeout(() => tooltip.style.display = 'none', 120);
    });
}

// ── CRUD Admin Logic ───────────────────────────────────────────
function renderGlossaryEditor() {
    const list = document.getElementById('keyword-admin-list');
    if (!list) return;
    list.innerHTML = '';
    Object.entries(KEYWORDS).forEach(([key, val]) => {
        const row = document.createElement('div');
        row.className = 'admin-row';
        row.innerHTML = `
            <input type="text" value="${key}" class="key-edit" readonly>
            <input type="text" value="${val}" class="val-edit">
            <button onclick="deleteKey('${key}')">Delete</button>
        `;
        list.appendChild(row);
    });
}

function addKeyword() {
    const k = document.getElementById('new-key').value.toUpperCase();
    const v = document.getElementById('new-val').value;
    if (k && v) {
        KEYWORDS[k] = v;
        renderGlossaryEditor();
    }
}

function deleteKey(k) {
    delete KEYWORDS[k];
    renderGlossaryEditor();
}

async function saveKeywords() {
    // Collect values from inputs
    const rows = document.querySelectorAll('.admin-row');
    const updated = {};
    rows.forEach(row => {
        const k = row.querySelector('.key-edit').value;
        const v = row.querySelector('.val-edit').value;
        updated[k] = v;
    });
    
    const res = await fetch('/update-keywords', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(updated)
    });
    if (res.ok) alert("Glossary Updated!");
    fetchKeywords();
}

// ── Navigation ────────────────────────────────────────────────
function loadExample(num) {
    if (!num) return;
    fetch('/get-example/' + num)
        .then(res => res.json())
        .then(data => {
            renderPane('left', data.left);
            renderPane('right', data.right);
            container.style.display = 'flex';
        });
}

function renderPane(side, file) {
    document.getElementById(side + '-title').textContent = file.name;
    const pre = document.getElementById(side + '-content');
    pre.innerHTML = '';
    pre.appendChild(buildHoverableContent(file.content));
    attachHoverListeners(pre);
}

document.getElementById('showExample').onclick = () => loadExample(select.value);
document.getElementById('toggleAdmin').onclick = () => {
    const el = document.getElementById('admin-panel');
    el.style.display = el.style.display === 'none' ? 'block' : 'none';
};

fetchKeywords();