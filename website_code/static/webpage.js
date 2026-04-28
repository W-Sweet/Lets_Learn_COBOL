const select    = document.getElementById('example-select');
const container = document.getElementById('text-container');

// ── COBOL keyword dictionary ───────────────────────────────────
const KEYWORDS = {
  'IDENTIFICATION': 'Starts the Identification Division — contains program metadata like PROGRAM-ID.',
  'DIVISION':       'Marks the start of a major COBOL division (IDENTIFICATION, ENVIRONMENT, DATA, PROCEDURE).',
  'PROGRAM-ID':     'Names the program. Must match the filename in most compilers.',
  'ENVIRONMENT':    'Starts the Environment Division — describes the hardware/file environment.',
  'DATA':           'Starts the Data Division — declares all variables, files, and working storage.',
  'PROCEDURE':      'Starts the Procedure Division — contains the actual program logic.',
  'DISPLAY':        'Writes text to the console/SYSOUT. e.g. DISPLAY "Hello World!".',
  'STOP':           'Terminates program execution. STOP RUN ends the entire run unit.',
  'RUN':            'Used with STOP (STOP RUN) to terminate the program.',
};

// ── Tooltip element ────────────────────────────────────────────
const tooltip = document.createElement('div');
tooltip.id = 'cobol-tooltip';
Object.assign(tooltip.style, {
  position:      'fixed',
  background:    '#1e1e2e',
  color:         '#cdd6f4',
  padding:       '7px 11px',
  borderRadius:  '6px',
  fontSize:      '12.5px',
  maxWidth:      '300px',
  boxShadow:     '0 4px 16px rgba(0,0,0,0.45)',
  zIndex:        '9999',
  pointerEvents: 'none',
  display:       'none',
  lineHeight:    '1.5',
  border:        '1px solid #45475a',
  whiteSpace:    'pre-wrap',
});
document.body.appendChild(tooltip);

let hideTimer = null;

function positionTooltip(x, y) {
  tooltip.style.display = 'block';
  const pad = 12;
  const tw  = tooltip.offsetWidth;
  const th  = tooltip.offsetHeight;
  let tx = x + 14;
  let ty = y - th - 10;
  if (tx + tw > window.innerWidth  - pad) tx = x - tw - 14;
  if (ty < pad)                           ty = y + 22;
  tooltip.style.left = tx + 'px';
  tooltip.style.top  = ty + 'px';
}

function hideTooltip() {
  tooltip.style.display = 'none';
}

// ── Tokenise content into hoverable spans ──────────────────────
function buildHoverableContent(text) {
  const fragment = document.createDocumentFragment();
  text.split('\n').forEach((line, i) => {
    if (i > 0) fragment.appendChild(document.createTextNode('\n'));
    const parts = line.split(/(\s+|[(),;.]+)/);
    parts.forEach(part => {
      if (!part) return;
      if (/^\s+$/.test(part) || /^[(),;.]+$/.test(part)) {
        fragment.appendChild(document.createTextNode(part));
        return;
      }
      const tip = KEYWORDS[part.toUpperCase()];
      if (tip) {
        const span = document.createElement('span');
        span.textContent = part;
        span.className   = 'tok tok-known';
        span.dataset.tip = tip;
        fragment.appendChild(span);
      } else {
        fragment.appendChild(document.createTextNode(part));
      }
    });
  });
  return fragment;
}

// ── Attach hover listeners to a <pre> element ─────────────────
function attachHoverListeners(preEl) {
  preEl.addEventListener('mouseover', function (e) {
    const span = e.target.closest('.tok-known');
    if (!span) return;
    clearTimeout(hideTimer);
    tooltip.textContent = span.dataset.tip;
    positionTooltip(e.clientX, e.clientY);
  });

  preEl.addEventListener('mousemove', function (e) {
    if (e.target.closest('.tok-known') && tooltip.style.display !== 'none') {
      positionTooltip(e.clientX, e.clientY);
    }
  });

  preEl.addEventListener('mouseout', function (e) {
    if (e.target.closest('.tok-known')) {
      hideTimer = setTimeout(hideTooltip, 120);
    }
  });
}

// ── State ──────────────────────────────────────────────────────
let currentFiles = [];
let leftIndex    = 0;
let rightIndex   = 1;

// ── Render a pane with hoverable keywords ─────────────────────
function renderPane(side, index) {
  const file = currentFiles[index];
  if (!file) return;
  document.getElementById(side + '-title').textContent = file.name;
  const preEl = document.getElementById(side + '-content');
  preEl.innerHTML = '';
  preEl.appendChild(buildHoverableContent(file.content));
  attachHoverListeners(preEl);
}

function loadExample(num) {
  if (!num) return;
  select.value = num;
  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/get-example/' + num, true);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const data   = JSON.parse(xhr.responseText);
      currentFiles = [data.left, data.right];
      leftIndex    = 0;
      rightIndex   = 1;
      renderPane('left',  leftIndex);
      renderPane('right', rightIndex);
      container.style.display = 'flex';
    }
  };
  xhr.send();
}

// ── Button listeners ───────────────────────────────────────────
document.getElementById('showExample').addEventListener('click', function () {
  loadExample(select.value);
});

document.getElementById('prevExample').addEventListener('click', function () {
  var cur = parseInt(select.value) || 2;
  loadExample(cur === 1 ? 4 : cur - 1);
});

document.getElementById('nextExample').addEventListener('click', function () {
  var cur = parseInt(select.value) || 0;
  loadExample(cur === 4 ? 1 : cur + 1);
});

document.getElementById('rotateLeft').addEventListener('click', function () {
  if (!currentFiles.length) return;
  let next = (leftIndex + 1) % currentFiles.length;
  if (next === rightIndex) next = (next + 1) % currentFiles.length;
  leftIndex = next;
  renderPane('left', leftIndex);
});

document.getElementById('rotateRight').addEventListener('click', function () {
  if (!currentFiles.length) return;
  let next = (rightIndex + 1) % currentFiles.length;
  if (next === leftIndex) next = (next + 1) % currentFiles.length;
  rightIndex = next;
  renderPane('right', rightIndex);
});