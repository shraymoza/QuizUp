import { useState } from 'react'

export default function GenerateQuiz() {
    const [file, setFile] = useState(null)

    const handleUpload = (e) => {
        e.preventDefault()
        alert(`Pretending to upload file: ${file?.name || 'none'}`)
    }

    return (
        <div style={{ textAlign: 'center', padding: '2rem' }}>
            <h2>Generate Quiz</h2>
            <form onSubmit={handleUpload}>
                <input type="file" onChange={(e) => setFile(e.target.files[0])} />
                <button type="submit" style={{ marginLeft: '1rem' }}>Upload</button>
            </form>
        </div>
    )
}
