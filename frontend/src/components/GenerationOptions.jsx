import PropTypes from "prop-types";

const OPTIONS = [
  { id: "study_notes", label: "Generate Study Notes" },
  { id: "quiz", label: "Generate Quiz (5 questions)" }
];

export function GenerationOptions({ selected, onSelect }) {
  return (
    <div className="card">
      <h2 className="card-title">Choose Output</h2>
      <div className="form-grid">
        {OPTIONS.map((option) => (
          <label key={option.id} className={`option-card${selected === option.id ? " selected" : ""}`}>
            <input
              type="radio"
              name="generationOption"
              value={option.id}
              checked={selected === option.id}
              onChange={() => onSelect(option.id)}
            />
            <span>{option.label}</span>
          </label>
        ))}
      </div>
    </div>
  );
}

GenerationOptions.propTypes = {
  selected: PropTypes.oneOf(OPTIONS.map((option) => option.id)).isRequired,
  onSelect: PropTypes.func.isRequired
};

export const GENERATION_OPTIONS = OPTIONS;
