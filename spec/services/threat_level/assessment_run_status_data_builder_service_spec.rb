require 'rails_helper'

describe ThreatLevel::AssessmentRunStatusDataBuilderService do
  context 'run is finished' do
    let!(:finished_run) { create(:threat_assessment_run, status: 'finished') }
    it 'returns status "finished"' do
      expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(finished_run)).
          to eq finished_run_status_data
    end
  end
  context 'run started less than 1 hour ago and is not finished' do
    let(:run) do
      create(
        :threat_assessment_run,
        threat_assessments: [create(:threat_assessment)],
        status: 'started',
        start_date: Time.now,
        end_date: nil
      )
    end
    context 'no results yet' do
      it 'returns status "started" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq started_run_status_data
      end
    end
    context 'results present' do
      context 'results produced less than two hours ago' do
        before do
          create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now)
          create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now + 1.hours)
        end
        it 'return status "running" with explanation' do
          expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
            to eq running_run_status_data
        end
      end
    end
  end

  context 'run started more than hour ago and less than five hours ago' do
    let(:run) do
      create(
        :threat_assessment_run,
        threat_assessments: [create(:threat_assessment)],
        status: 'started',
        start_date: Time.now - 4.hours,
        end_date: nil
      )
    end
    context 'no results yet' do
      it 'returns status "warning" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq warning_run_status_data
      end
    end
    context 'results produced more than two hours ago and less than five hours ago' do
      before do
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 3.hours)
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 4.hours)
      end
      it 'return status "warning" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq warning_run_status_data
      end
    end
    context 'results produced less than two hours ago' do
      before do
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 1.hours)
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now)
      end
      it 'return status "running" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq running_run_status_data
      end
    end
  end

  context 'run started more than five hours ago' do
    let(:run) do
      create(
        :threat_assessment_run,
        threat_assessments: [create(:threat_assessment)],
        status: 'started',
        start_date: Time.now - 6.hours,
        end_date: nil
      )
    end
    context 'no results' do
      it 'return status "error" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq error_run_status_data
      end
    end

    context 'results produced more than five hours ago' do
      before do
        create(:result, threat_assessment: run.threat_assessments.first,
               created_at: Time.now - 6.hours)
        create(:result, threat_assessment: run.threat_assessments.first,
               created_at: Time.now - 7.hours)
      end
      it 'return status "error" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq error_run_status_data
      end
    end

    context 'results produced more than two hours ago and less than five hours ago' do
      before do
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 3.hours)
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 4.hours)
      end
      it 'return status "warning" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq warning_run_status_data
      end
    end

    context 'results produced less than two hours ago' do
      before do
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now - 1.hours)
        create(:result, threat_assessment: run.threat_assessments.first, created_at: Time.now)
      end
      it 'return status "running" with explanation' do
        expect(ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)).
          to eq running_run_status_data
      end
    end

  end
end

private
def finished_run_status_data
  {
    start_date: finished_run.start_date,
    status: :finished,
    explanation: 'Assessment run finished'
  }
end

def started_run_status_data
  {
    start_date: run.start_date,
    status: :started,
    explanation: 'Assessment run started less than one hour ago and has not produced any results'
  }
end

def running_run_status_data
  {
    start_date: run.start_date,
    status: :running,
    explanation: 'Assessment run has results produced less than two hours ago'
  }
end

def warning_run_status_data
  {
    start_date: run.start_date,
    status: :warning,
    explanation: 'Assessment run has not produced result in the past two hours'
  }
end

def error_run_status_data
  {
    start_date: run.start_date,
    status: :error,
    explanation: 'Assessment run has not produced result in the past five hours'
  }
end