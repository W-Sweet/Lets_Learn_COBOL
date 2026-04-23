const select    = document.getElementById('example-select');
const container = document.getElementById('text-container');

function loadExample(num) {
  if (!num) return;
  select.value = num;

  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/get-example/' + num, true);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        var data = JSON.parse(xhr.responseText);
        document.getElementById('left-title').textContent   = data.left.name;
        document.getElementById('left-content').textContent = data.left.content;
        document.getElementById('right-title').textContent   = data.right.name;
        document.getElementById('right-content').textContent = data.right.content;
        container.style.display = 'flex';
    }
};
  xhr.send();
}

document.getElementById('showExample').addEventListener('click', function () {
  console.log('pressing show example button');
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