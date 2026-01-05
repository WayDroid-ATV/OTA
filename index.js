const AVAILABLE_IMG_TYPES = [
  ['system', 'arm64', 'GAPPS'],
  ['system', 'x86_64', 'GAPPS'],

  ['system', 'arm64', 'VANILLA'],
  ['system', 'x86_64', 'VANILLA'],

  ['vendor', 'arm64', 'MAINLINE'],
  ['vendor', 'x86_64', 'MAINLINE']
];

async function getLatestRelease(img, arch, type) {
  const update_channel = await fetch(`/${img}/waydroid_tv_${arch}/${type}.json`).then(r => r.json());
  return update_channel.response[0];
}

async function updateTable(img, arch, type) {
  const table          = document.getElementById(`${img}-images`),
        img_info       = await getLatestRelease(img, arch, type),
        img_table_elem = document.createElement('tr');

  img_table_elem.innerHTML = `
    <td>${arch}</td>
    <td>${type}</td>
    <td>${new Date(img_info.datetime * 1000).toISOString().split('T')[0]}</td>
    <td>${img_info.asb}</td>
    <td><a class="button" href="${img_info.url}">SourceForge</a></td>
  `;

  table.appendChild(img_table_elem);
}

window.onload = async () => { for (types of AVAILABLE_IMG_TYPES) await updateTable(...types); };
