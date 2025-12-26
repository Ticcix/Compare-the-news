<section class="flat-section flat-contact">
    <div class="container">
        <div class="comparison-wrapper" id="compare-container" style="display:none;">
            <div class="table-scroll">
                <table id="compare-table">
                    <thead>
                        <tr id="header-row">
                            <th>
                              Features
                            </th>
                        </tr>
                    </thead>
                    <tbody id="specs-body">
                    </tbody>
                </table>
            </div>
        </div>

        <div id="empty-message" class="info-box">
            <h6>
              Information
            </h6>
            <p class="note">
              Comparison list is empty.
            </p>
            <a href="/" class="btn btn-primary text-white mt-3 mb-3 btn-raised position-left">
               Back to Home
            </a>
        </div>

    </div>
</section>
<script>
    document.addEventListener("DOMContentLoaded", () => {

        const fieldsMap = {
            {compare_fields} // Example: 'yearbuilt': 'Year Built', 'bathrooms': 'Bathrooms', etc.
        };

        const container = document.getElementById('compare-container');
        const emptyMsg = document.getElementById('empty-message');
        const headerRow = document.getElementById('header-row');
        const specsBody = document.getElementById('specs-body');

        loadComparison();

        function loadComparison() {
            fetch('/engine/ajax/controller.php?mod=compare_news')
                .then(res => res.json())
                .then(response => {
                    if (response.status === 'empty' || response.data.length === 0) {
                        container.style.display = 'none';
                        emptyMsg.style.display = 'block';
                        return;
                    }

                    container.style.display = 'block';
                    emptyMsg.style.display = 'none';

                    renderTable(response.data);
                })
                .catch(err => console.error("Error loading comparison:", err));
        }

        function renderTable(properties) {
            const headerRow = document.getElementById('header-row');
            const specsBody = document.getElementById('specs-body');

            headerRow.innerHTML = '<th>მახასიათებლები</th>';
            specsBody.innerHTML = '';

            properties.forEach(prop => {
                const th = document.createElement('th');
                th.innerHTML = `
            <div class="property-card-header">
                <button class="remove-btn" onclick="removeItem(${prop.id})" title="Remove">&times;</button>
                <img src="${prop.image}" data-fancybox data-caption="${prop.title}" alt="${prop.title}" class="prop-image">
                <div>
                  <a href="${prop.url}">  <div class="prop-title">${prop.title}</div></a>
                    <div class="prop-address">${prop.specs.street || ''}</div>
                </div>
            </div>
        `;
                headerRow.appendChild(th);
            });

          
            for (const [key, label] of Object.entries(fieldsMap)) {
                const tr = document.createElement('tr');
                tr.innerHTML = `<td>${label}</td>`;

                properties.forEach(prop => {
                    const td = document.createElement('td');
                    let val = prop.specs[key] ? prop.specs[key] : '';

                    if (!val) {
                        td.innerHTML = '<span class="text-muted">—</span>';
                    }
                    else if (val === 'yes' || val === '1') {
                        td.innerHTML = '<span class="text-success"><i class="fa fa-check"></i></span>';
                    }
                    else if (val === 'no' || val === '0') {
                        td.innerHTML = '<span class="text-danger"><i class="fa fa-times"></i></span>';
                    }
                    else {
                        // Regular text value
                        td.innerHTML = val;
                    }
                    tr.appendChild(td);
                });
                specsBody.appendChild(tr);
            }
        }

        window.removeItem = function (id) {
            const confirmText = "ნამდვილად გსურთ წაშლა?";
            const titleText = "დადასტურება";

            DLEconfirm(confirmText, titleText, function () {
                fetch(`/engine/ajax/controller.php?mod=compare_news&action=remove&id=${id}`)
                    .then(res => res.json())
                    .then(data => {
                        if (data.status === 'success') {
                            loadComparison();
                        } else {
                        }
                    })
                    .catch(err => console.error('Error:', err));

            });
        };

    });
</script>

<style>
    .comparison-wrapper {
  margin: 0 auto;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.table-scroll {
  overflow-x: auto;
  position: relative;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 800px;
  table-layout: fixed;
}

th,
td {
  padding: 16px 24px;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
  border-right: 1px solid #e5e7eb;
  width: 300px;
  vertical-align: middle;
}

th:first-child,
td:first-child {
  width: 200px;
  background-color: white;
  font-weight: 600;
  color: #6b7280;
  position: sticky;
  left: 0;
  z-index: 10;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
}

thead th {
  background-color: white;
  position: sticky;
  top: 0;
  z-index: 20;
}

thead th:first-child {
  z-index: 30;
}

.property-card-header {
  display: flex;
  flex-direction: column;
  gap: 10px;
  position: relative;
}

.prop-image {
  width: 100%;
  height: 180px;
  object-fit: cover;
  border-radius: 8px;
  background-color: #e5e7eb;
}

.prop-title {
  font-size: 1.1rem;
  font-weight: 700;
  color: #1f2937;
  line-height: 1.4;
}

.prop-price {
  font-size: 1.25rem;
  font-weight: 800;
}

.prop-address {
  font-size: 0.85rem;
  color: #6b7280;
}

.remove-btn {
  position: absolute;
  top: 0;
  right: 0;
  background: #fff3f3;
  border: none;
  color: #ef4444;
  cursor: pointer;
  width: 30px;
  height: 30px;
  border-radius: 0 0 0 20%;
  display: block;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  transition: 0.2s;
  z-index: 2;
}



.remove-btn:hover {
  scale: calc(1.1);
}

tbody tr:nth-child(even) td {
  background-color: #f9fafb;
}

tbody tr:nth-child(even) td:first-child {
  background-color: #fff;
}


@media (max-width: 768px) {
  body {
    padding: 10px;
  }

  .prop-image {
    height: 140px;
  }

  th,
  td {
    max-width: 240px;
  }
}
</style>