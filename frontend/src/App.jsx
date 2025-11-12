import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'
import Home from './pages/Home'
import GenerateQuiz from './pages/GenerateQuiz'

import { useEffect, useState } from "react";

function App() {
    const [data, setData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const testApi = async () => {
            try {
                const res = await fetch(`${import.meta.env.VITE_API_URL}/generate`);
                if (!res.ok) throw new Error(`HTTP error! Status: ${res.status}`);
                const json = await res.json();
                setData(json);
            } catch (err) {
                console.error("Error calling API:", err);
                setError(err.message);
            }
        };

        testApi();
    }, []);

    return (
        <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
            <h1>🔍 Testing API Gateway Connection</h1>
            {error && <p style={{ color: "red" }}>Error: {error}</p>}
            <pre>{data ? JSON.stringify(data, null, 2) : "Loading..."}</pre>
        </div>
    );
}

export default App;
