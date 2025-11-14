import PropTypes from "prop-types";

export function OutputPanel({ isLoading, result, requestType }) {
  if (isLoading) {
    return (
      <section className="output-section">
        <div className="output-card">Processing your document...</div>
      </section>
    );
  }

  if (!result) {
    return null;
  }

  return (
    <section className="output-section">
      <div className="output-card">
        <h3>{requestType === "quiz" ? "Generated Quiz" : "Study Notes"}</h3>
        {Array.isArray(result?.items) ? (
          <ol>
            {result.items.map((item, index) => (
              <li key={index} style={{ marginBottom: "1rem" }}>
                <strong>{item.title ?? `Item ${index + 1}`}</strong>
                <p>{item.content ?? item.question}</p>
                {item.options ? (
                  <ul>
                    {item.options.map((option, idx) => (
                      <li key={idx}>{option}</li>
                    ))}
                  </ul>
                ) : null}
                {item.answer ? <p>Answer: {item.answer}</p> : null}
              </li>
            ))}
          </ol>
        ) : (
          <pre>{result?.content ?? JSON.stringify(result, null, 2)}</pre>
        )}
      </div>
    </section>
  );
}

OutputPanel.propTypes = {
  isLoading: PropTypes.bool.isRequired,
  result: PropTypes.shape({
    items: PropTypes.arrayOf(
      PropTypes.shape({
        title: PropTypes.string,
        content: PropTypes.string,
        question: PropTypes.string,
        options: PropTypes.arrayOf(PropTypes.string),
        answer: PropTypes.string
      })
    ),
    content: PropTypes.string
  }),
  requestType: PropTypes.oneOf(["study_notes", "quiz"]).isRequired
};
