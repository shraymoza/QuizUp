import { Navigate, Route, Routes } from "react-router-dom";

import { AppLayout } from "./components/AppLayout.jsx";
import { UploadPage } from "./pages/UploadPage.jsx";
import { HistoryPage } from "./pages/HistoryPage.jsx";

function App() {
  return (
    <Routes>
      <Route element={<AppLayout />}>
        <Route index element={<Navigate to="upload" replace />} />
        <Route path="upload" element={<UploadPage />} />
        <Route path="history" element={<HistoryPage />} />
      </Route>
    </Routes>
  );
}

export default App;
