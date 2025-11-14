import PropTypes from "prop-types";
import { useCallback, useRef, useState } from "react";

export function FileUploadPanel({ onFileSelected }) {
  const inputRef = useRef(null);
  const [fileName, setFileName] = useState(null);
  const [isDragging, setIsDragging] = useState(false);

  const handleFiles = useCallback(
    (files) => {
      const [file] = files;
      if (!file) return;
      if (file.type !== "application/pdf") {
        alert("Please upload a PDF file");
        return;
      }
      setFileName(file.name);
      onFileSelected(file);
    },
    [onFileSelected]
  );

  const onDrop = useCallback(
    (event) => {
      event.preventDefault();
      setIsDragging(false);
      if (event.dataTransfer?.files) {
        handleFiles(event.dataTransfer.files);
      }
    },
    [handleFiles]
  );

  const onDragOver = useCallback((event) => {
    event.preventDefault();
    setIsDragging(true);
  }, []);

  const onDragLeave = useCallback((event) => {
    event.preventDefault();
    setIsDragging(false);
  }, []);

  return (
    <div className="card">
      <h2 className="card-title">Upload Lecture Material</h2>
      <p>Select a PDF from your device or drag it into the dropzone.</p>
      <div
        className={`upload-dropzone${isDragging ? " dragging" : ""}`}
        onDrop={onDrop}
        onDragOver={onDragOver}
        onDragLeave={onDragLeave}
        role="presentation"
        onClick={() => inputRef.current?.click()}
      >
        <p>{fileName ? `Selected: ${fileName}` : "Drop PDF here or click to browse"}</p>
        <input
          ref={inputRef}
          type="file"
          accept="application/pdf"
          style={{ display: "none" }}
          onChange={(event) => handleFiles(event.target.files)}
        />
      </div>
    </div>
  );
}

FileUploadPanel.propTypes = {
  onFileSelected: PropTypes.func.isRequired
};
