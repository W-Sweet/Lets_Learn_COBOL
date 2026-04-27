const select    = document.getElementById('example-select');
const container = document.getElementById('text-container');

// State: current files for this example, and which file index each pane shows
let currentFiles = [];
let leftIndex  = 0;
let rightIndex = 1;

function renderPane(side, index) {
  const file = currentFiles[index];
  if (!file) return;
  document.getElementById(side + '-title').textContent   = file.name;
  document.getElementById(side + '-content').textContent = file.content;
}

function loadExample(num) {
  if (!num) return;
  select.value = num;

  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/get-example/' + num, true);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      currentFiles = JSON.parse(xhr.responseText);
      leftIndex  = 0;
      rightIndex = 1;
      renderPane('left',  leftIndex);
      renderPane('right', rightIndex);
      container.style.display = 'flex';
    }
  };
  xhr.send();
}

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

// Rotate buttons — cycle to the next file, skipping the index the other pane uses
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