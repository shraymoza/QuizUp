import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'
import Home from './pages/Home'
import GenerateQuiz from './pages/GenerateQuiz'

function App() {
    return (
        <Router>
            <nav style={{ padding: '1rem', background: '#282c34', color: 'white' }}>
                <Link to="/" style={{ marginRight: '1rem', color: 'white' }}>Home</Link>
                <Link to="/generate" style={{ color: 'white' }}>Generate Quiz</Link>
            </nav>

            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/generate" element={<GenerateQuiz />} />
            </Routes>
        </Router>
    )
}

export default App
