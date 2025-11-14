import { useCallback, useMemo, useState } from "react";

import { FileUploadPanel } from "../components/FileUploadPanel.jsx";
import { GenerationOptions } from "../components/GenerationOptions.jsx";
import { OutputPanel } from "../components/OutputPanel.jsx";
import { useUploadGeneration } from "../hooks/useUploadGeneration.js";

export function UploadPage() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [requestType, setRequestType] = useState("study_notes");
  const [topic, setTopic] = useState("");

  const uploadMutation = useUploadGeneration();

  const handleGenerate = useCallback(() => {
    if (!selectedFile) {
      alert("Please upload a PDF first");
      return;
    }

    uploadMutation.mutate({
      file: selectedFile,
      requestType,
      topic: topic.trim() || undefined
    });
  }, [selectedFile, requestType, topic, uploadMutation]);

  const disabled = useMemo(() => !selectedFile || uploadMutation.isPending, [selectedFile, uploadMutation.isPending]);

  return (
    <div className="form-grid">
      <FileUploadPanel onFileSelected={setSelectedFile} />

      <div className="card">
        <label className="card-title" htmlFor="topicInput">
          Optional Topic Focus
        </label>
        <input
          id="topicInput"
          type="text"
          placeholder="e.g., Linear Regression Fundamentals"
          value={topic}
          onChange={(event) => setTopic(event.target.value)}
          style={{
            padding: "0.75rem 1rem",
            borderRadius: "0.75rem",
            border: "1px solid #cbd5f5",
            fontSize: "1rem"
          }}
        />
      </div>

      <GenerationOptions selected={requestType} onSelect={setRequestType} />

      <div className="card" style={{ display: "flex", justifyContent: "flex-end" }}>
        <button className="button" type="button" disabled={disabled} onClick={handleGenerate}>
          {uploadMutation.isPending ? "Generating..." : "Generate"}
        </button>
      </div>

      <OutputPanel requestType={requestType} isLoading={uploadMutation.isPending} result={uploadMutation.data} />
      {uploadMutation.isError ? (
        <div className="output-section">
          <div className="output-card" style={{ color: "#dc2626" }}>
            {uploadMutation.error?.response?.data?.message ?? uploadMutation.error?.message ?? "Something went wrong"}
          </div>
        </div>
      ) : null}
    </div>
  );
}
