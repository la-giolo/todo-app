let DragAndDrop = {
  mounted() {
    console.log("Drag and Drop hook called")
    let draggedEl = null

    this.el.querySelectorAll("tbody tr").forEach(row => {
      row.setAttribute("draggable", "true")

      row.addEventListener("dragstart", e => {
        draggedEl = row
        e.dataTransfer.effectAllowed = "move"
      })

      row.addEventListener("dragover", e => {
        e.preventDefault()
        let target = e.target.closest("tr")
        if (target && target !== draggedEl) {
          let tbody = this.el.querySelector("tbody")
          let draggedIndex = Array.from(tbody.children).indexOf(draggedEl)
          let targetIndex = Array.from(tbody.children).indexOf(target)

          if (draggedIndex < targetIndex) {
            tbody.insertBefore(draggedEl, target.nextSibling)
          } else {
            tbody.insertBefore(draggedEl, target)
          }
        }
      })

      row.addEventListener("drop", e => {
        e.preventDefault()
        let tbody = this.el.querySelector("tbody")
        let rows = Array.from(tbody.children)

        let draggedId = draggedEl.dataset.id
        let movedIndex = rows.findIndex(row => row.dataset.id === draggedId)
        console.log("ROWS: ", rows)
        console.log("Dragged element: ", draggedId)

        let beforeEl = rows[movedIndex - 1] || null
        let nextEl = rows[movedIndex + 1] || null

        console.log("Drag and Drop ID: ", draggedId)
        this.pushEvent("reorder_task", {
          moved_id: draggedId,
          before_id: beforeEl ? beforeEl.dataset.id : null,
          next_id: nextEl ? nextEl.dataset.id : null
        })
      })
    })
  }
}

export default DragAndDrop
