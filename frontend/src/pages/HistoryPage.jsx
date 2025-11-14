import { useQuery } from "@tanstack/react-query";

import { fetchHistory } from "../services/api.js";

export function HistoryPage() {
  const { data, isLoading, isError, error } = useQuery({
    queryKey: ["history"],
    queryFn: fetchHistory
  });

  if (isLoading) {
    return <div className="card">Loading history...</div>;
  }

  if (isError) {
    return <div className="card">Error loading history: {error.message}</div>;
  }

  if (!data || data.length === 0) {
    return <div className="history-empty">No generation history yet. Your generated notes and quizzes will appear here.</div>;
  }

  return (
    <div className="form-grid">
      {data.map((item) => (
        <div className="card" key={item.id}>
          <h3 style={{ marginTop: 0 }}>{item.title ?? item.documentName ?? `Request ${item.id?.substring(0, 8)}`}</h3>
          <p>Type: {item.requestType ?? "N/A"}</p>
          <p>Created: {item.createdAt ? new Date(item.createdAt).toLocaleString() : "N/A"}</p>
          {item.summary ? <p>{item.summary}</p> : null}
          {item.documentKey ? <p>Document: {item.documentKey}</p> : null}
        </div>
      ))}
    </div>
  );
}
